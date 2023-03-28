require "rails_helper"

RSpec.describe "Sakes" do
  let!(:sakes) { create_list(:sake, 3) }
  let(:id) { sakes[0].id }

  context "without login" do
    describe "GET /sakes request (index)" do
      it "returns 200 response" do
        get sakes_path
        expect(response).to have_http_status "200"
      end
    end

    describe "GET /sakes/[id] request (show)" do
      it "returns 200 response" do
        get sake_path(id)
        expect(response).to have_http_status "200"
      end
    end

    describe "GET /sakes/new request (new)" do
      it "redirects to user login page" do
        get new_sake_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET /sakes/[id]/edit (edit)" do
      it "redirects to user login page" do
        get edit_sake_path(id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "POST /sakes (create)" do
      it "redirects to user login page" do
        post sakes_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET /sakes/[id] (update)" do
      it "redirects to user login page" do
        patch sake_path(id, params: { sake: { bottle_level: "empty" } })
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "DELETE /sakes/[id] (destroy)" do
      it "redirects to user login page" do
        delete sake_path(id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET /sakes/menu request (menu)" do
      it "returns 200 response" do
        get menu_sakes_path
        expect(response).to have_http_status "200"
      end
    end
  end

  context "with logined user" do
    before do
      user = create(:user)
      sign_in(user)
    end

    describe "GET /sakes/[id]/edit (edit)" do
      it "returns 200 response" do
        get edit_sake_path(id)
        expect(response).to have_http_status "200"
      end
    end

    describe "POST /sakes (create)" do
      it "returns 303 response" do
        # HACK: FactoryBotで作った適当なsakeをparamsにして使う
        #       idやcreated_atなどが含まれるが、permitされてないのでparamsで渡して問題ない
        sake_params = build(:sake).attributes
        post "/sakes", params: { sake: sake_params }
        expect(response).to have_http_status "303" # see other, and redirect to "sakes/[new_id]"
      end

      it "increase 1 sake" do
        sake_params = build(:sake).attributes
        expect { post "/sakes", params: { sake: sake_params } }.to change(Sake, :count).by 1
      end
    end

    describe "GET /sakes/[id] (update)" do
      let(:orig) { sakes[0].bottle_level }
      let(:updated) { "empty" }

      it "redirects to showing updated sake" do
        patch sake_path(id, params: { sake: { bottle_level: updated } })
        expect(response).to redirect_to sake_path(id)
      end

      it "updates sake state with patched params" do
        expect {
          patch sake_path(id, params: { sake: { bottle_level: updated } })
          sakes[0].reload
        }.to change(sakes[0], :bottle_level).from(orig).to(updated)
      end
    end

    describe "DELETE /sakes/[id] (destroy)" do
      it "redirects to index page" do
        delete sake_path(id)
        expect(response).to redirect_to sakes_path
      end

      it "decrease 1 sake" do
        expect { delete sake_path(id) }.to change(Sake, :count).by(-1)
      end
    end
  end
end
