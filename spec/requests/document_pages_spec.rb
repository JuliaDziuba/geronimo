require 'spec_helper'


describe "Document pages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	
	before { sign_in user }

	describe "index page" do

    describe "when there are no documents" do
			before { visit documents_path }

			it { should have_selector('h1', text: "Documents") }
      it { should have_selector('p', text: "There are no saved documents yet.") }
      
    end

    describe	"when there are documents" do
			let!(:doc1)  { FactoryGirl.create(:document, user: user, category: Document::INVOICE) }
      let!(:doc2)  { FactoryGirl.create(:document, user: user, category: :CONSIGNMENT) }
      let!(:doc3)  { FactoryGirl.create(:document, user: user, category: :INVOICE) }
      let!(:doc4)  { FactoryGirl.create(:document, user: user, category: :CONSIGNMENT) }

      describe "but no category is specified" do 
        before { visit documents_path }

        it { should have_selector('h1', text: "Documents") }
        it { should have_selector('th', content: "Category") }
        pending( 'table should have four rows')
      end

      describe "and a category is specified" do
        before { visit documents_path(:category => :INVOICE) }

        it { should have_selector('a', text: "Documents") }
        it { should have_selector('h1', text: "Invoice") }
        it { should have_selector('th', content: "Category") }
        pending( 'table should have three rows')
      end
      
    end

  end

  describe  "new page" do
    
    describe "when there is no category specified" do

      it { should have_selector('a', text: "Documents") }
      it { should have_selector('h1', text: "New") }
      it { should have_selector('p', text: "Document type") }
      it { should_not have_selector('p', text: "Date") }
      pending( 'when document type is selected and "Create Document" is selected the new page should be generated again but with the updated form.')

    end

    describe "when there is a category specified" do
      before { visit (new_document_path(:category => :INVOICE))}

      it { should have_selector('a', text: "Documents") }
      it { should have_selector('a', text: :INVOICE) }
      it { should have_selector('h1', text: "New") }
      it { should_not have_selector('p', text: "Document type") }
      it { should_not have_selector('p', text: "Date") }

      describe "and an invalid document is created" do
        pending('when a document fields are filled in and "Create Document" selected the document count increases by one and the page is the index.')

      end

      describe "and a valid document is created" do
        pending('when a document fields are filled in and "Create Document" selected the document count increases by one and the page is the index.')

      end      
    end

  end

  describe  "show page" do

    describe "of a consignment document" do
      let(:doc) { FactoryGirl.create(:document, user: user, category: :CONSIGNMENT) }
			before { visit document_path(doc) }
	    
	    it { should have_selector('a', text:  "Documents") }
      it { should have_selector('a', text:  :CONSIGNMENT) }
	    it { should have_selector('h1', text: doc.name) }
    end

    describe "of an invoice document" do
      let(:doc) { FactoryGirl.create(:document, user: user, category: :INVOICE) }
      before { visit document_path(doc) }
      
      it { should have_selector('a', text:  "Documents") }
      it { should have_selector('a', text:  :INVOICE) }
      it { should have_selector('h1', text: doc.name) }
    end

    describe "of a price list document" do
      let(:doc) { FactoryGirl.create(:document, user: user, category: :PRICE) }
      before { visit document_path(doc) }
      
      it { should have_selector('a', text:  "Documents") }
      it { should have_selector('a', text:  :PRICE) }
      it { should have_selector('h1', text: doc.name) }
    end

    describe "of a portfolio document" do
      let(:doc) { FactoryGirl.create(:document, user: user, category: :PORTFOLIO) }
      before { visit document_path(doc) }
      
      it { should have_selector('a', text:  "Documents") }
      it { should have_selector('a', text: :PORTFOLIO) }
      it { should have_selector('h1', text: doc.name) }
    end

	end
end
