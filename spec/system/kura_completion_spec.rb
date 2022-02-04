require "rails_helper"

RSpec.describe "KuraCompletion", type: :system do
  describe "autocompletion of kura form", js: true do
    let(:user) { FactoryBot.create(:user) }

    before do
      sign_in(user)
      visit new_sake_path
    end

    context "with valid text, same by completion" do
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

    context "with invalid text" do
      before do
        fill_in("sake_kura_todofuken_autocompletion", with: "最強蔵（）").send_keys(:tab)
      end

      it "inputs '' to hidden kura form" do
        expect(find(:test_id, "sake_kura", visible: false).value).to eq("")
      end

      it "inputs '' to hidden todofuken form" do
        expect(find(:test_id, "sake_todofuken", visible: false).value).to eq("")
      end
    end

    context "when deleting text, after inputing valid text" do
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
end
