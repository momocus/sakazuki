require "rails_helper"

RSpec.describe "Sakes" do
  let!(:sakes) { FactoryBot.create_list(:sake, 3) }
  let(:id) { sakes[0].id }

  context "without login" do
    describe "GET /sakes request (index)" do
      it "returns 200 response" do
        get sakes_path
        expect(response).to have_http_status "200"
      end
    end

    describe "GET /sakes.json request (index)" do
      before do
        get sakes_path(format: :json)
      end

      it "returns 200 response" do
        expect(response).to have_http_status "200"
      end

      it "returns all sakes json" do
        json = JSON.parse(response.body)
        expect(json.present?).to be true
      end
    end

    describe "GET /sakes/[id] request (show)" do
      it "returns 200 response" do
        get sake_path(id)
        expect(response).to have_http_status "200"
      end

      it "returns 1 sake json" do
        get sake_path(id, format: :json)
        json = JSON.parse(response.body)
        expect(json.present?).to be true
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
  end

  context "with logined user" do
    before do
      user = FactoryBot.create(:user)
      sign_in(user)
    end

    describe "GET /sakes/[id]/edit (edit)" do
      it "returns 200 response" do
        get edit_sake_path(id)
        expect(response).to have_http_status "200"
      end
    end

    describe "POST /sakes (create)" do
      # HACK: FactoryBotで作った適当なsakeを、JSON経由でhashにすることでparamsとして使う
      sake_params = JSON.parse(FactoryBot.build(:sake).to_json)
      sake_params.delete(:id)
      sake_params.delete(:created_at)
      sake_params.delete(:updated_at)

      it "returns 302 response" do
        post "/sakes", params: { sake: sake_params }
        expect(response).to have_http_status "302" # redirect to "sakes/[new_id]"
      end

      it "increase 1 sake" do
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
        expect do
          patch sake_path(id, params: { sake: { bottle_level: updated } })
          sakes[0].reload
        end.to change(sakes[0], :bottle_level).from(orig).to(updated)
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
