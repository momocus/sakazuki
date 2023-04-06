require "rails_helper"

RSpec.describe FlashHelper do
  # arg `type` order
  # "notice", "alert", :copy_sake, :create_sake, :delete_sake, :open_sake, :empty_sake, other
  describe "flash_type" do
    it "returns success for notice" do
      expect(helper.flash_type("notice")).to eq("success")
    end

    it "returns danger for alert" do
      expect(helper.flash_type("alert")).to eq("danger")
    end

    it "returns info for copy_sake" do
      expect(helper.flash_type(:copy_sake)).to eq("info")
    end

    it "returns success for create_sake" do
      expect(helper.flash_type(:create_sake)).to eq("success")
    end

    it "returns success for delete_sake" do
      expect(helper.flash_type(:delete_sake)).to eq("success")
    end

    it "returns success for open_sake" do
      expect(helper.flash_type(:open_sake)).to eq("success")
    end

    it "returns success for empty_sake" do
      expect(helper.flash_type(:empty_sake)).to eq("success")
    end

    it "returns light for other" do
      expect(helper.flash_type("")).to eq("light")
    end
  end

  describe "flash_message" do
    context "with :notice" do
      it "returns text value" do
        text = "ログインしました。"
        expect(helper.flash_message(:notice, text)).to eq(text)
      end
    end

    context "with :alert" do
      it "returns text value" do
        text = "ログインもしくはアカウント登録してください。"
        expect(helper.flash_message(:alert, text)).to eq(text)
      end
    end

    context "with :copy_sake" do
      it "returns text including sake link" do
        sake = { name: "ほしいずみ", id: 1 }
        link = 'href="/sakes/1'
        expect(helper.flash_message(:copy_sake, sake)).to include(link)
      end

      it "returns text including sake name" do
        sake = { name: "ほしいずみ", id: 1 }
        text = I18n.t("helper.flash.copy_sake", name: "ほしいずみ")
        expect(helper.flash_message(:copy_sake, sake)).to have_text(text)
      end
    end

    context "with :create_sake" do
      it "returns text including sake link" do
        sake = { name: "ほしいずみ", id: 1 }
        link = 'href="/sakes/1'
        expect(helper.flash_message(:create_sake, sake)).to include(link)
      end

      it "returns text including sake name" do
        sake = { name: "ほしいずみ", id: 1 }
        text = I18n.t("helper.flash.create_sake", name: "ほしいずみ")
        expect(helper.flash_message(:create_sake, sake)).to have_text(text)
      end
    end

    context "with :delete_sake" do
      it "returns text including sake name" do
        name = "ほしいずみ"
        text = I18n.t("helper.flash.delete_sake", name:)
        expect(helper.flash_message(:delete_sake, name)).to have_text(text)
      end
    end

    context "with :open_sake" do
      it "returns text including sake link" do
        sake = { "name" => "ほしいずみ", "id" => 1 }
        link = 'href="/sakes/1'
        expect(helper.flash_message(:open_sake, sake)).to include(link)
      end

      it "returns text including sake name" do
        sake = { "name" => "ほしいずみ", "id" => 1 }
        link = I18n.t("helper.flash.review")
        text = I18n.t("helper.flash.open_sake", name: "ほしいずみ", link:)
        expect(helper.flash_message(:open_sake, sake)).to have_text(text)
      end

      it "returns text including sake link to review" do
        sake = { "name" => "ほしいずみ", "id" => 1 }
        link = 'href="/sakes/1/edit?review=true'
        expect(helper.flash_message(:open_sake, sake)).to include(link)
      end

      it "returns text including review text" do
        sake = { "name" => "ほしいずみ", "id" => 1 }
        text = I18n.t("helper.flash.review")
        expect(helper.flash_message(:open_sake, sake)).to have_text(text)
      end
    end

    context "with :empty_sake" do
      it "returns text including sake link" do
        sake = { "name" => "ほしいずみ", "id" => 1 }
        link = 'href="/sakes/1'
        expect(helper.flash_message(:empty_sake, sake)).to include(link)
      end

      it "returns text including sake name" do
        sake = { "name" => "ほしいずみ", "id" => 1 }
        text = I18n.t("helper.flash.empty_sake", name: "ほしいずみ")
        expect(helper.flash_message(:empty_sake, sake)).to have_text(text)
      end
    end

    context "with other" do
      it "returns text value" do
        text = "何かが起きました"
        expect(helper.flash_message("", text)).to include(text)
      end
    end
  end
end
