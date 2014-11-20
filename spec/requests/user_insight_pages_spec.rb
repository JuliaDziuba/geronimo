require 'spec_helper'

describe "User insight pages" do
  let(:user) { FactoryGirl.create(:user) }
     
  before { sign_in user }

  subject { page }

  describe "snapshot view" do

    let!(:w1) { FactoryGirl.create(:work, user: user, inventory_id: 'work1', title: 'work1', expense_hours: 1, expense_materials: 5, quantity: 1) }
    let!(:w2) { FactoryGirl.create(:work, user: user, inventory_id: 'work2', title: 'work2', expense_hours: 2, expense_materials: 5, quantity: 2) }  
    let!(:w3) { FactoryGirl.create(:work, user: user, inventory_id: 'work3', title: 'work3', expense_hours: 1, expense_materials: 5, quantity: 3) }  
    let!(:w4) { FactoryGirl.create(:work, user: user, inventory_id: 'work4', title: 'work4', expense_hours: 2, expense_materials: 5, quantity: 4) }    
    let!(:v1) { FactoryGirl.create(:venue, user: user, name: "venue1") }
    let!(:v2) { FactoryGirl.create(:venue, user: user, name: "venue2") }
    let!(:c1) { FactoryGirl.create(:client, user: user, name: "client1") }
    let!(:c2) { FactoryGirl.create(:client, user: user, name: "client2") } 
    let!(:a1) { FactoryGirl.create(:activity, user: user, category_id: Activity::SALE[:id], venue: v1, client: c1, date_start: Date.today - 13.months, date_end: Date.today - 13.months) }
    let!(:a2) { FactoryGirl.create(:activity, user: user, category_id: Activity::SALE[:id], venue: v2, client: c2, date_start: Date.today - 13.months, date_end: Date.today - 13.months) }
    let!(:a3) { FactoryGirl.create(:activity, user: user, category_id: Activity::SALE[:id], venue: v1, client: c1, date_start: Date.today - 7.months, date_end: Date.today - 7.months) }
    let!(:a4) { FactoryGirl.create(:activity, user: user, category_id: Activity::SALE[:id], venue: v2, client: c2, date_start: Date.today - 7.months, date_end: Date.today - 7.months) }
    let!(:a5) { FactoryGirl.create(:activity, user: user, category_id: Activity::SALE[:id], venue: v1, client: c1, date_start: Date.today - 2.months, date_end: Date.today - 2.months) }
    let!(:a6) { FactoryGirl.create(:activity, user: user, category_id: Activity::SALE[:id], venue: v2, client: c2, date_start: Date.today - 2.months, date_end: Date.today - 2.months) }
    let!(:a7) { FactoryGirl.create(:activity, user: user, category_id: Activity::SHOW[:id], venue: v1, client: c1, date_start: Date.today - 2.weeks, date_end: Date.today - 2.weeks) }
    let!(:a8) { FactoryGirl.create(:activity, user: user, category_id: Activity::SALE[:id], venue: v2, client: c2, date_start: Date.today - 2.weeks, date_end: Date.today - 1.weeks) }
          
    let!(:r1) { FactoryGirl.create(:activitywork, activity: a1, work: w1, quantity: 1, sold: 1) }
    let!(:r2) { FactoryGirl.create(:activitywork, activity: a1, work: w2, quantity: 2, sold: 2) }
    let!(:r3) { FactoryGirl.create(:activitywork, activity: a2, work: w3, quantity: 3, sold: 3) }
    let!(:r4) { FactoryGirl.create(:activitywork, activity: a2, work: w4, quantity: 4, sold: 4) }
    let!(:r5) { FactoryGirl.create(:activitywork, activity: a3, work: w1, quantity: 5, sold: 5) }
    let!(:r6) { FactoryGirl.create(:activitywork, activity: a3, work: w2, quantity: 6, sold: 6) }
    let!(:r7) { FactoryGirl.create(:activitywork, activity: a4, work: w3, quantity: 7, sold: 7) }
    let!(:r8) { FactoryGirl.create(:activitywork, activity: a4, work: w4, quantity: 8, sold: 8) }
    let!(:r9) { FactoryGirl.create(:activitywork, activity: a5, work: w1, quantity: 9, sold: 9) }
    let!(:r10) { FactoryGirl.create(:activitywork, activity: a5, work: w2, quantity: 10, sold: 10) }
    let!(:r11) { FactoryGirl.create(:activitywork, activity: a6, work: w3, quantity: 11, sold: 11) }
    let!(:r12) { FactoryGirl.create(:activitywork, activity: a6, work: w4, quantity: 12, sold: 12) }
    let!(:r13) { FactoryGirl.create(:activitywork, activity: a7, work: w1, quantity: 13, income: 13, retail: 26, sold: 13) }
    let!(:r14) { FactoryGirl.create(:activitywork, activity: a7, work: w2, quantity: 14, income: 14, retail: 28, sold: 14) }
    let!(:r15) { FactoryGirl.create(:activitywork, activity: a8, work: w3, quantity: 25, income: 15, retail: 30, sold: 15) }
    let!(:r16) { FactoryGirl.create(:activitywork, activity: a8, work: w4, quantity: 26, income: 16, retail: 32, sold: 16) }
 
    describe "works sold" do

      before { visit insight_user_path(user) }

      it { should have_content("hello") }

      # describe "annual absolutes" do       
        
      #   it { should have_selector("table#AnnualAbsoluteSoldWorkTotals tbody tr[1] td[2]", text: "58") } #count within past month
      #   it { should have_selector("table#AnnualAbsoluteSoldWorkTotals tbody tr[1] td[3]", text: "100") } #count within past 6 months
      #   it { should have_selector("table#AnnualAbsoluteSoldWorkTotals tbody tr[1] td[4]", text: "126") } #count within past year
      #   it { should have_selector("table#AnnualAbsoluteSoldWorkTotals tbody tr[1] td[5]", text: "136") } #count within past 5 years
      #   it { should have_selector("table#AnnualAbsoluteSoldWorkTotals tbody tr[2] td[2]", text: "1692") } #retail within past month
      #   it { should have_selector("table#AnnualAbsoluteSoldWorkTotals tbody tr[3] td[2]", text: "846") } #income within past month
      #   it { should have_selector("table#AnnualAbsoluteSoldWorkTotals tbody tr[4] td[2]", text: "290") } #material within past month
      #   it { should have_selector("table#AnnualAbsoluteSoldWorkTotals tbody tr[5] td[2]", text: "556") } #profit within past month
      #   it { should have_selector("table#AnnualAbsoluteSoldWorkTotals tbody tr[6] td[2]", text: "88") } #hours within past month
      # end

      # describe "annual average" do

      #   it { should have_selector("table#AnnualAverageSoldWorkTotals tbody tr[1] td[2]", text: "6.32") } #wage within past month
      #   it { should have_selector("table#AnnualAverageSoldWorkTotals tbody tr[2] td[2]", text: "29.17") } #income within past month
      #   it { should have_selector("table#AnnualAverageSoldWorkTotals tbody tr[3] td[2]", text: "14.59") } #retail within past month
      #   it { should have_selector("table#AnnualAverageSoldWorkTotals tbody tr[4] td[2]", text: "5.0") } #material within past month
      #   it { should have_selector("table#AnnualAverageSoldWorkTotals tbody tr[5] td[2]", text: "9.59") } #profit within past month
      #   it { should have_selector("table#AnnualAverageSoldWorkTotals tbody tr[6] td[2]", text: "1.52") } #hours within past month
      # end

      # describe "by category" do
      #   it { should have_selector("table#sold_works_by_category tbody tr[1] td[1]", text: "Uncategorized") } #wage within past month
      #   it { should have_selector("table#sold_works_by_category tbody tr[1] td[2]", text: "58 ($846.00)") } #count (income) within past month
      #   it { should have_selector("table#sold_works_by_category tbody tr[1] td[3]", text: "100 ($1056.00)") } #count (income) within past 6 months
      # end

      # describe "by venue" do 
      #   it { should have_selector("table#sold_works_by_venue tbody tr[1] td[1]", text: "venue1") } #name of first venue
      #   it { should have_selector("table#sold_works_by_venue tbody tr[1] td[2]", text: "27 ($365.00)") } #count (income) within past month
      #   it { should have_selector("table#sold_works_by_venue tbody tr[1] td[3]", text: "46 ($460.00)") } #count (income) within past 6 months
      # end

      # describe "by client" do 
      #   it { should have_selector("table#sold_works_by_client tbody tr[1] td[1]", text: "client1") } #name of first client
      #   it { should have_selector("table#sold_works_by_client tbody tr[1] td[2]", text: "27 ($365.00)") } #count (income) within past month
      #   it { should have_selector("table#sold_works_by_client tbody tr[1] td[3]", text: "46 ($460.00)") } #count (income) within past 6 months
      # end

      # describe "by work" do 
      #   it { should have_selector("table#sold_works_by_client tbody tr[1] td[1]", text: "work1") } #name of first work
      #   it { should have_selector("table#sold_works_by_client tbody tr[1] td[2]", text: "13 ($169.00)") } #count (income) within past month
      #   it { should have_selector("table#sold_works_by_client tbody tr[1] td[3]", text: "22 ($214.00)") } #count (income) within past 6 months
      #   it { should have_selector("table#sold_works_by_client tbody tr[2] td[1]", text: "work2") } #name of second work   
      # end


    end

    describe "status of works" do
      let!(:a9) { FactoryGirl.create(:activity, user: user, category_id: Activity::CONSIGNMENT[:id], venue: v2, client: c2, date_start: Date.today - 2.weeks, date_end: Date.today - 2.weeks) }
    

      before { visit insight_user_path(user) }

    end

  end 

  describe "annual view" do

  end

end