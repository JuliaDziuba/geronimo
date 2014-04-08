class NotesController < ApplicationController
  before_filter :signed_in_user

  def index
    @notes = Note.all_for_users(current_user.id);
  end

  def new
    referer = request.referer
    referer_type = referer.split('/')[-2]
    referer_id = referer.split('/')[-1]
    session[:return_to] = referer
    @type = Note::TYPE_HASH_BY_REFERER[referer_type]
    if @type.nil?
      @note = Note.new
      @works = current_user.works.all
      @venues = current_user.venues.all
      @clients = current_user.clients.all

    else
      object = objectGivenTypeFromReferer(@type, referer_id)
      @crumb_name = crumbNameGivenType(@type, object)
      @crumb_path = crumbPathGivenType(@type, object)
      @note = Note.new(notable_type: @type[:type], notable_id: object.id)
      @works = []
      @venues = []
      @clients = []
    end
  end

  def edit
    @note = Note.find(params[:id])
    @type = Note::TYPE_HASH_BY_TYPE[@note.notable_type]
    @object = objectGivenTypeFromNote(@type, @note.notable_id)
    @crumb_name = crumbNameGivenType(@type, @object)
    @crumb_path = crumbPathGivenType(@type, @object)
  end

  def create
    session[:return_to] ||= request.referer
    @note = Note.new(params[:note])
    if @note.notable_type == "User"
      @note.notable_id = current_user.id
    end
    if @note.save
    #  flash[:success] = "Your params #{params[:note]}!"
      redirect_to session.delete(:return_to)
    else
      @type = Note::TYPE_HASH_BY_TYPE[@note.notable_type]
      object = objectGivenTypeFromNote(@type, @note.notable_id)
      @crumb_name = crumbNameGivenType(@type, object)
      @crumb_path = crumbPathGivenType(@type, object)
      render 'new'
    end
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:success] = "Changes have been saved!"
      redirect_to notes_path
    else
      @type = Note::TYPE_HASH_BY_TYPE[@note.notable_type]
      object = objectGivenTypeFromNote(@type, @note.notable_id)
      @crumb_name = crumbNameGivenType(@type, object)
      @crumb_path = crumbPathGivenType(@type, object)
      render 'edit'
    end
  end

  def update_multiple
    session[:return_to] = request.referer
    ids = []
    params[:notes].keys.each do |id|
      ids.push(id)
    end
    @notes = Note.update(params[:notes].keys, params[:notes].values).reject { |w| w.errors.empty? }
    if @notes.empty?
      flash[:notice] = "Notes have been updated!"
      redirect_to session.delete(:return_to)
    else
      render 'new'
    end
  end

  def objectGivenTypeFromReferer(type, ref)
    if type == Note::WORK
      object = current_user.works.find_by_inventory_id(ref)
    elsif type == Note::VENUE
      object = current_user.venues.find_by_munged_name(ref)
    elsif type == Note::CLIENT
      object = current_user.clients.find_by_munged_name(ref)
    elsif type == Note::USER 
      object = User.find(id)
    end
    object
  end

  def objectGivenTypeFromNote(type, id)
    if type == Note::WORK
      object = current_user.works.find(id)
    elsif type == Note::VENUE
      object = current_user.venues.find(id)
    elsif type == Note::CLIENT
      object = current_user.clients.find(id)
    elsif type == Note::USER 
      object = User.find(id)
    end
    object
  end

  def crumbNameGivenType(type, object)
    if type == Note::WORK
      crumb_name = object.title
    elsif type == Note::VENUE
      crumb_name = object.name
    elsif type == Note::CLIENT
      crumb_name = object.name
    elsif type == Note::USER
      crumb_name = object.name
    end
    crumb_name
  end

  def crumbPathGivenType(type, object)
    if type == Note::WORK
      crumb_path = work_path(object)
    elsif type == Note::VENUE
      crumb_path = venue_path(object)
    elsif type == Note::CLIENT
      crumb_path = client_path(object)
    elsif type == Note::USER
      crumb_path = user_path(object)
    end
    crumb_path
  end
end