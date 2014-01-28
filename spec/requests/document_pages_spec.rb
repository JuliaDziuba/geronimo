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

    describe "when there are documents" do
                        let!(:doc1)  { FactoryGirl.create(:document, user: user, category: Document::INVOICE) }
      let!(:doc2)  { FactoryGirl.create(:document, user: user, category: Document::CONSIGNMENT) }
      let!(:doc3)  { FactoryGirl.create(:document, user: user, category: Document::INVOICE) }
      let!(:doc4)  { FactoryGirl.create(:document, user: user, category: Document::CONSIGNMENT) }

      describe "but no category is specified" do 
        before { visit documents_path }

        it { should have_selector('h1', text: "Documents") }
        it { should have_selector('th', content: "Category") }
        it { should have_selector('table tbody tr', :count => 4) }
      end

      describe "and a category is specified" do
        before { visit documents_path(:category => Document::INVOICE) }

        it { should have_selector('a', text: "Documents") }
        it { should have_selector('h1', text: "Invoice") }
        it { should have_selector('th', content: "Category") }
        it { should have_selector('table tbody tr', :count => 2) }
      end
      
    end

  end

  describe  "show page" do

    describe "of a consignment document" do
      let!(:doc) { FactoryGirl.create(:document, user: user, category: Document::CONSIGNMENT) }
      before { visit document_path(doc) }
      
      it { should have_selector('a', text:  "Documents") }
      it { should have_selector('a', text:  Document::CONSIGNMENT) }
      it { should have_selector('h1', text: doc.name) }
    end

    describe "of an invoice document" do
      let!(:doc) { FactoryGirl.create(:document, user: user, category: Document::INVOICE) }
      before { visit document_path(doc) }
      
      it { should have_selector('a', text:  "Documents") }
      it { should have_selector('a', text:  Document::INVOICE) }
      it { should have_selector('h1', text: doc.name) }
    end

    describe "of a price list document" do
      let!(:doc) { FactoryGirl.create(:document, user: user, category: Document::PRICE) }
      before { visit document_path(doc) }
      
      it { should have_selector('a', text:  "Documents") }
      it { should have_selector('a', text:  Document::PRICE) }
      it { should have_selector('h1', text: doc.name) }
    end

    describe "of a portfolio document" do
      let!(:doc) { FactoryGirl.create(:document, user: user, category: Document::PORTFOLIO) }
      before { visit document_path(doc) }
      
      it { should have_selector('a', text:  "Documents") }
      it { should have_selector('a', text: Document::PORTFOLIO) }
      it { should have_selector('h1', text: doc.name) }
    end

  end

  describe  "new page" do

    let(:create) { "Create Document" }
    
    describe "when there is no category specified" do
      before { visit new_document_path }

      it { should have_selector('a', text: "Documents") }
      it { should have_selector('h1', text: "New") }
      it { should have_selector('label', text: "Document type") }
      it { should_not have_selector('label', text: "Date") }

      describe "with invalid information" do 
        it "should not create a new document" do
          expect { click_button create}.not_to change(Document, :count)
        end

        describe "it should not set the document category" do
          before { click_button create }

          it { should have_selector('a', text: "Documents") }
          it { should have_selector('h1', text: "New") }
          it { should have_selector('label', text: "Document type") }
          it { should_not have_selector('label', text: "Date") }
        end
      end

      describe "with valid category information" do
        before do 
          select Document::CONSIGNMENT, from: "Document type"
        end

        it "should not create a new document" do
          expect { click_button create }.not_to change(Document, :count)
        end

        describe "it should set the category for the document" do
          before { click_button create }

          it { should have_selector('a', text: Document::CONSIGNMENT) }
          it { should_not have_selector('label', text: "Document type") }
          it { should have_selector('label', text: "Date") }
        end

      end

    end

    describe "when there is a category specified" do
      let!(:w) { FactoryGirl.create(:work, user: user, title: "Test work", inventory_id: "123") }
      before { visit (new_document_path(:category => Document::PORTFOLIO))}

      it { should have_selector('a', text: "Documents") }
      it { should have_selector('a', text: Document::PORTFOLIO) }
      it { should have_selector('h1', text: "New") }
      it { should_not have_selector('label', text: "Document type") }
      it { should have_selector('label', text: "Date") }

      describe "and an invalid document is created" do
        before { click_button create }

          it { should have_selector('a', text: Document::PORTFOLIO) }
          it { should_not have_selector('label', text: "Document type") }
          it { should have_selector('label', text: "Date") }
          it { should have_content ("error") }
      end

      describe "and a valid document is created" do
        before do 
          fill_in "document_name",  with: "Portfolio test"
          fill_in "Date",           with: "2013-04-05"
          fill_in "document_maker", with: "Test Maker"
          find(:xpath, "//input[@id='subjects_123_share_public']").set(true)
        end
        
        it "should create a new document" do
          expect { click_button create }.to change(Document, :count).by(1)
        end

        describe "it should bring users to the show page of the new document" do
          before { click_button create }

          it { should have_selector('h1', text: "Portfolio test") }
          it { should_not have_selector('label', text: "Document type") }
          it { should_not have_selector('label', text: "Date") }

        end

      end      
    end
  end

end