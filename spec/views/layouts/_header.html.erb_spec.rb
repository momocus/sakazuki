require "rails_helper"

# Capybaraを使うためにsystem specを指定する
RSpec.describe "layouts/_header", type: :system do
  describe "header links" do
    context "with signed in admin user" do
      let(:user) { create(:user, admin: true) }

      before do
        sign_in(user)
        visit root_path
      end

      it "does not have sign in link" do
        expect { find(:test_id, "sign-in") }.to raise_error(Capybara::ElementNotFound)
      end

      it "has elasticsearch link" do
        expect(find(:test_id, "elasticsearch")).to have_link("Elasticsearch", href: elasticsearch_path)
      end

      it "has user edit link" do
        expect(find(:test_id, "user-edit")).to have_link(user.email, href: edit_user_registration_path)
      end

      it "has invitation link" do
        expect(find(:test_id, "invitation")).to have_link(I18n.t("layouts.header.invitation"), href: new_user_invitation_path)
      end

      it "has sign out link" do
        expect(find(:test_id, "sign-out")).to have_link(I18n.t("layouts.header.sign_out"), href: destroy_user_session_path)
      end
    end

    context "with signed in non admin user" do
      let(:user) { create(:user, admin: false) }

      before do
        sign_in(user)
        visit root_path
      end

      it "does not have sign in link" do
        expect { find(:test_id, "sign-in") }.to raise_error(Capybara::ElementNotFound)
      end

      it "has elasticsearch link" do
        expect(find(:test_id, "elasticsearch")).to have_link("Elasticsearch", href: elasticsearch_path)
      end

      it "has user edit link" do
        expect(find(:test_id, "user-edit")).to have_link(user.email, href: edit_user_registration_path)
      end

      it "does not have invitation link" do
        expect { find(:test_id, "invitation") }.to raise_error(Capybara::ElementNotFound)
      end

      it "has sign out link" do
        expect(find(:test_id, "sign-out")).to have_link(I18n.t("layouts.header.sign_out"), href: destroy_user_session_path)
      end
    end

    context "with not signed in user" do
      before do
        visit root_path
      end

      it "has sign in link" do
        expect(find(:test_id, "sign-in")).to have_link(I18n.t("layouts.header.sign_in"), href: new_user_session_path)
      end

      it "has elasticsearch link" do
        expect(find(:test_id, "elasticsearch")).to have_link("Elasticsearch", href: elasticsearch_path)
      end

      it "does not have user edit link" do
        expect { find(:test_id, "user-edit") }.to raise_error(Capybara::ElementNotFound)
      end

      it "does not have invitation link" do
        expect { find(:test_id, "invitation") }.to raise_error(Capybara::ElementNotFound)
      end

      it "does not have sign out link" do
        expect { find(:test_id, "sign-out") }.to raise_error(Capybara::ElementNotFound)
      end
    end
  end
end
