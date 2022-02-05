require "rails_helper"

RSpec.describe "KuraCompletion", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in(user)
  end

  describe "autocompletion of kura form in new sake page", js: true do
    before do
      visit new_sake_path
    end

    # 一文字以上の蔵名と県名に対して、「蔵名（県名）」のフォーマット
    context "with valid format" do
      before do
        # "send_keys(:tab)" is to trigger change event.
        # https://github.com/teamcapybara/capybara/issues/2105
        fill_in("sake_kura_todofuken_autocompletion", with: "原田酒造合資会社（愛知県）").send_keys(:tab)
      end

      it "inputs '原田酒造合資会社' to hidden kura form" do
        expect(find(:test_id, "sake_kura", visible: false).value).to eq("原田酒造合資会社")
      end

      it "inputs '愛知県' to hidden todofuken form" do
        expect(find(:test_id, "sake_todofuken", visible: false).value).to eq("愛知県")
      end
    end

    context "with invalid format" do
      before do
        fill_in("sake_kura_todofuken_autocompletion", with: "適当な蔵（）").send_keys(:tab)
      end

      it "inputs same text to hidden kura form" do
        expect(find(:test_id, "sake_kura", visible: false).value).to eq("適当な蔵（）")
      end

      it "inputs '' to hidden todofuken form" do
        expect(find(:test_id, "sake_todofuken", visible: false).value).to eq("")
      end
    end

    context "when deleting text" do
      before do
        fill_in("sake_kura_todofuken_autocompletion", with: "原田酒造合資会社（愛知県）").send_keys(:tab)
        fill_in("sake_kura_todofuken_autocompletion", with: "").send_keys(:tab)
      end

      it "inputs '' to hidden kura form" do
        expect(find(:test_id, "sake_kura", visible: false).value).to eq("")
      end

      it "inputs '' to hidden todofuken form" do
        expect(find(:test_id, "sake_todofuken", visible: false).value).to eq("")
      end
    end
  end

  describe "restore kura form at existing sake edit page", js: true do
    let!(:sake) { FactoryBot.create(:sake, kura: "原田酒造合資会社", todofuken: "愛知県") }

    it "has formatted value in visible kura form" do
      visit edit_sake_path(sake.id)
      expect(find(:test_id, "sake_kura_todofuken_autocompletion").value).to eq("原田酒造合資会社（愛知県）")
    end
  end
end
