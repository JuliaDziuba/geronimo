class DocumentsController < ApplicationController
  def new
    @document = getCurrentUserForForm(params[:category])
    @subjects = getSubjectsForForm(@document.category, @document.subject)
  end

  def create
    @document = current_user.documents.build(params[:document])
    if @document.name == "VanillaDocument"
      if Document::DOCUMENTS_ARRAY.include? @document.category
        @document = getCurrentUserForForm(params[:document][:category])
      else
        @document = getCurrentUserForForm(nil)
      end
      @subjects = getSubjectsForForm(@document.category, @document.subject)
      render 'new'
    else 
      subject =  setDocumentSubject(@document, params[:subjects])
      @document.assign_attributes(:subject => subject ) 
      if @document.save
        redirect_to document_url(@document)
      else
        @subjects = getSubjectsForForm(@document.category, @document.subject)
        flash[:error] = "There was an error in the document."
        render 'new'
      end
    end
  end

  def edit
    @document = current_user.documents.find_by_munged_name(params[:id])
    @subjects = getSubjectsForForm(@document.category, @document.subject)
    render 'new'
  end

  def update
    @document = current_user.documents.find_by_munged_name(params[:id]) 
    @document.assign_attributes(params[:document])
    subject =  setDocumentSubject(@document, params[:subjects])
    @document.assign_attributes(:subject => subject )
    if @document.valid?
      @document.save
      redirect_to document_url(@document)
    else
      @subjects = getSubjectsForForm(@document.category, @document.subject)
      flash[:error] = "There was an error with updates to the document."
      render 'new'
    end
  end

  def show
    @document = current_user.documents.find_by_munged_name(params[:id])
    @update_subjects = params[:subjects]
    @subject_contact = getSubjectContact(@document.subject)
    @subjects = getSubjectsForDocument(@document)
  end

  def index
    if params.has_key?(:category)
      @category = params[:category]
      @documents = current_user.documents.where('documents.category = ?', @category)
    else
      @documents = current_user.documents.all
    end
  end

  def getCurrentUserForForm(category)
    document = current_user.documents.build(
      category: category,
      maker: current_user.name,
      maker_phone: current_user.phone, 
      maker_email: current_user.email, 
      maker_site: current_user.domain || (about_user(current_user) if current_user.share_about), 
      maker_address_street: current_user.address_street, 
      maker_address_city: current_user.address_city, 
      maker_address_state: current_user.address_state, 
      maker_address_zipcode: current_user.address_zipcode
    )
    document
  end

  def getSubjectsForForm(category, subject)
    if category == Document::CONSIGNMENT
      subjects = current_user.venues.all
    elsif category == Document::INVOICE
      subjects = current_user.clients.all
    elsif category == Document::PORTFOLIO || category == Document::PRICE
      subjects = current_user.works.all
      subjectArray = (subject || "").split(',')
      subjects.each do |subject|
        if subjectArray.include? subject.inventory_id
          subject.share_public = true
        else 
          subject.share_public = false
        end
      end
      subjects = subjects.sort_by &:title
    end
    subjects
  end

  def setDocumentSubject(document, subjects)
    if document.category == Document::PRICE || document.category == Document::PORTFOLIO
      subject = ""
      subjects.each do |key,value|
        if value["share_public"]  == "1"
          subject = subject + key + ","
        end
      end
    else
      subject = document.subject
    end
    subject
  end

  def getSubjectContact(document)
    if @document.category == Document::CONSIGNMENT
      subject = current_user.venues.find_by_id(@document.subject)
    elsif @document.category == Document::INVOICE
      subject = current_user.clients.find_by_id(@document.subject)
    end
    if !subject.nil?
      @subject_contact = {
        "name" => subject.name,
        "number" => subject.phone,
        "email" => subject.email,
        "address_street" => subject.address_street,
        "address_state" => subject.address_state, 
        "address_zipcode" => subject.address_zipcode
      }
    else 
      @subject_contact = Hash.new
    end
    @subject_contact
  end

  def getSubjectsForDocument(document)
    if document.category == Document::CONSIGNMENT
      subjects = current_user.activities.currentConsignmentsAtVenueBetweenDates(document.subject, document.date_start, document.date_end)
      saleInfoOnSubjects = current_user.activities.salesAtVenueBetweenDates(document.subject, document.date_start, document.date_end)
    elsif document.category == Document::INVOICE
      subjects = current_user.activities.salesToClientBetweenDates(document.subject, document.date_start, document.date_end)
    else
      subjects = current_user.works.where('works.inventory_id IN (?)', (document.subject || "").split(','))
    end
    subjects
  end

end

