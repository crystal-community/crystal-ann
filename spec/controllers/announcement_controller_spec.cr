require "./spec_helper"

describe AnnouncementController do
  let(:user) { user(login: "JohnDoe").tap &.save }
  let(:another_user) { user(login: "superman").tap &.save }
  let(:admin_user) { user(login: "superman", role: "admin").tap &.save }

  let(:title) { "Announcement Controller Sample Title" }
  let(:announcement) { announcement(user, title: title).tap &.save }

  before do
    Announcement.clear
    User.clear
  end

  describe "GET index" do
    before { announcement }

    it "renders all the announcements" do
      get "/announcements"
      expect(response.status_code).to eq 200
      expect(response.body.includes? title).to be_true
    end

    context "with query param" do
      it "can find announcements matching title or description" do
        a1 = announcement(user, title: "This is amazing announcement").tap &.save
        a2 = announcement(user, title: "This announcement is also amazing").tap &.save
        a3 = announcement(user, title: "This announcement is just cool").tap &.save

        get "/announcements", body: "query=amazing"
        expect(response.body.includes? a1.title.to_s).to be_true
        expect(response.body.includes? a2.title.to_s).to be_true
        expect(response.body.includes? a3.title.to_s).to be_false
      end
    end

    context "with type param" do
      it "can find announcements by type" do
        a1 = announcement(user, type: 0).tap &.save
        a2 = announcement(user, type: 0).tap &.save
        a3 = announcement(user, type: 1).tap &.save

        get "/announcements", body: "type=#{Announcement::TYPES[0]}"
        expect(response.body.includes? a1.title.to_s).to be_true
      end
    end

    context "with user param" do
      it "can find announcements by user login" do
        user1 = user(login: "Superman").tap &.save
        user2 = user(login: "Batman").tap &.save

        a1 = announcement(user1, title: "Announcement1").tap &.save
        a2 = announcement(user1, title: "Announcement2").tap &.save
        a3 = announcement(user2, title: "Announcement3").tap &.save

        get "/announcements", body: "user=#{user1.login}"

        expect(response.body.includes? a1.title.to_s).to be_true
        expect(response.body.includes? a2.title.to_s).to be_true
        expect(response.body.includes? a3.title.to_s).to be_false
      end
    end
  end

  describe "GET show" do
    it "renders a single announcement" do
      get "/announcements/#{announcement.id}"
      expect(response.status_code).to eq 200
      expect(response.body.includes? title).to be_true
    end
  end

  describe "GET new" do
    it "render new template" do
      get "/announcements/new"
      expect(response.status_code).to eq 200
      expect(response.body.includes? "Make an Announcement").to be_true
    end

    context "rate limit reached" do
      before { login_as user; ENV["MAX_ANNS_PER_HOUR"] = "0" }
      after { ENV["MAX_ANNS_PER_HOUR"] = nil }

      it "shows rate limit message" do
        get "/announcements/new"
        expect(response.status_code).to eq 200
        expect(response.body.includes? "You can create up to").to be_true
      end
    end
  end

  describe "POST create" do
    context "when user signed-in" do
      before { login_as user }

      it "creates an announcement with valid params" do
        post "/announcements", body: "title=test-title&description=test-description&type=0"
        expect(Announcement.all.size).to eq 1
      end

      it "does not create an announcement with invalid params" do
        post "/announcements", body: "title=test-title"
        expect(Announcement.all.size).to eq 0
      end

      it "does not create an announcement if csrf token is invalid" do
        post "/announcements", body: "title=test-title&description=test-description&type=0&_csrf=invalid-token"
        expect(response.status_code).to eq 403
        expect(Announcement.all.size).to eq 0
      end

      context "and rate limit is reached" do
        before { ENV["MAX_ANNS_PER_HOUR"] = "0" }
        after { ENV["MAX_ANNS_PER_HOUR"] = nil }

        it "redirects to /" do
          post "/announcements", body: "title=test-title&description=test-description&type=0"
          expect(response.status_code).to eq 302
          expect(response).to redirect_to "/"
          expect(Announcement.all.size).to eq 0
        end
      end
    end

    context "when user not signed-in" do
      it "does not create an announcement with valid params" do
        post "/announcements", body: "title=test-title&description=test-description&type=0"
        expect(response.status_code).to eq 302
        expect(Announcement.all.size).to eq 0
      end

      it "redirects to /" do
        post "/announcements", body: "title=test-title&description=test-description&type=0"
        expect(response).to redirect_to "/announcements/new"
      end
    end
  end

  describe "GET edit" do
    context "when user not signed-in" do
      it "redirects to root_url" do
        get "/announcements/#{announcement.id}/edit"
        expect(response.status_code).to eq 302
        expect(response).to redirect_to "/"
      end
    end

    context "when user signed-in" do
      context "user can update this announcement" do
        before { login_as user }

        it "renders edit template" do
          get "/announcements/#{announcement.id}/edit"
          expect(response.status_code).to eq 200
          expect(response.body.includes? announcement.title.to_s).to be_true
        end
      end

      context "user can't update this announcement" do
        before { login_as another_user }

        it "redirects to root url" do
          get "/announcements/#{announcement.id}/edit"
          expect(response.status_code).to eq 302
          expect(response).to redirect_to "/"
        end
      end

      context "user is admin" do
        before { login_as admin_user }

        it "renders edit template" do
          get "/announcements/#{announcement.id}/edit"
          expect(response.status_code).to eq 200
          expect(response.body.includes? announcement.title.to_s).to be_true
        end
      end
    end
  end

  describe "PATCH update" do
    let(:valid_params) do
      {
        title:       "my super cool title",
        description: "my super cool description",
        type:        "1",
      }
    end
    let(:invalid_params) do
      {
        title:       "-",
        description: "too short",
        type:        "-1",
      }
    end

    context "when user not signed-in" do
      it "redirects to root url" do
        patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(valid_params)
        expect(response.status_code).to eq 302
        expect(response).to redirect_to "/"
      end

      it "does not update announcement" do
        patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(valid_params)
        expect(announcement.title).to eq title
      end
    end

    context "when user signed-in" do
      context "when user can update announcement" do
        before { login_as announcement.user.not_nil! }

        it "updates announcement if params are valid" do
          patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(valid_params)
          updated = Announcement.find(announcement.try &.id).not_nil!
          expect(updated.title).to eq valid_params[:title]
          expect(updated.description).to eq valid_params[:description]
          expect(updated.type).to eq valid_params[:type].to_i
        end

        it "redirects to announcement#show page if params are valid" do
          patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(valid_params)
          expect(response.status_code).to eq 302
          expect(response).to redirect_to "/announcements/#{announcement.id}"
        end

        it "does not update announcement if params are not valid" do
          patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(invalid_params)
          a = Announcement.find(announcement.try &.id).not_nil!
          expect(a.title).to eq announcement.title
          expect(a.description).to eq announcement.description
          expect(a.type).to eq announcement.type
        end

        it "renders announcement#edit page if params are not valid" do
          patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(invalid_params)
          expect(response.status_code).to eq 200
        end

        it "does not update announcement if csrf token is invalid" do
          patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(valid_params) + "&_csrf=invalid-token"
          expect(response.status_code).to eq 403
          a = Announcement.find(announcement.try &.id).not_nil!
          expect(a.title).to eq announcement.title
          expect(a.description).to eq announcement.description
          expect(a.type).to eq announcement.type
        end
      end

      context "when user cannot update announcement" do
        before { login_as another_user }

        it "does not update announcement" do
          patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(valid_params)
          a = Announcement.find(announcement.try &.id).not_nil!
          expect(a.title).to eq announcement.title
          expect(a.description).to eq announcement.description
          expect(a.type).to eq announcement.type
        end

        it "redirects to root url" do
          patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(valid_params)
          expect(response.status_code).to eq 302
          expect(response).to redirect_to "/"
        end
      end

      context "when user is admin" do
        before { login_as admin_user }

        it "updates announcement if params are valid" do
          patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(valid_params)
          updated = Announcement.find(announcement.try &.id).not_nil!
          expect(updated.title).to eq valid_params[:title]
          expect(updated.description).to eq valid_params[:description]
          expect(updated.type).to eq valid_params[:type].to_i
        end

        it "redirects to announcement#show page if params are valid" do
          patch "/announcements/#{announcement.id}", body: HTTP::Params.encode(valid_params)
          expect(response.status_code).to eq 302
          expect(response).to redirect_to "/announcements/#{announcement.id}"
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "when user not signed-in" do
      it "redirects to root url" do
        delete "/announcements/#{announcement.id}"
        expect(response.status_code).to eq 302
        expect(response).to redirect_to "/"
      end

      it "does not delete announcement" do
        delete "/announcements/#{announcement.id}"
        expect(Announcement.find(announcement.try &.id)).not_to be_nil
      end
    end

    context "when user signed-in" do
      context "when user can update announcement" do
        before { login_as announcement.user.not_nil! }

        it "deletes announcement" do
          delete "/announcements/#{announcement.id}"
          expect(Announcement.find announcement.id).to be_nil
        end

        it "redirects to root url" do
          delete "/announcements/#{announcement.id}"
          expect(response.status_code).to eq 302
          expect(response).to redirect_to "/"
        end

        it "does not delete announcement if csrf token is invalid" do
          delete "/announcements/#{announcement.id}", body: "_csrf=invalid-token"
          expect(response.status_code).to eq 403
          expect(Announcement.find announcement.id).not_to be_nil
        end
      end

      context "when user cannot update announcement" do
        before { login_as another_user }

        it "does not delete announcement" do
          delete "/announcements/#{announcement.id}"
          expect(Announcement.find announcement.id).not_to be_nil
        end

        it "redirects to root url" do
          delete "/announcements/#{announcement.id}"
          expect(response.status_code).to eq 302
          expect(response).to redirect_to "/"
        end
      end

      context "when user is admin" do
        before { login_as admin_user }

        it "deletes announcement" do
          delete "/announcements/#{announcement.id}"
          expect(Announcement.find announcement.id).to be_nil
        end

        it "redirects to root url" do
          delete "/announcements/#{announcement.id}"
          expect(response.status_code).to eq 302
          expect(response).to redirect_to "/"
        end
      end
    end
  end

  describe "GET expand" do
    context "when hashid is valid" do
      it "redirects to announcement page" do
        get "/=#{announcement.hashid}"
        expect(response.status_code).to eq 302
        expect(response).to redirect_to "/announcements/#{announcement.id}"
      end
    end

    context "when hashid is invalid" do
      it "redirecs to root url if hashid present" do
        get "/=invalid"
        expect(response.status_code).to eq 302
        expect(response).to redirect_to "/"
      end

      it "returns 404 if hashid is missing" do
        get "/="
        expect(response.status_code).to eq 404
        expect(response).not_to redirect_to "/"
      end
    end
  end

  describe "GET random" do
    before { announcement }

    it "redirects to a random announcement" do
      get "/announcements/random"
      expect(response.status_code).to eq 302
      expect(response).to redirect_to "/announcements/#{announcement.id}"
    end
  end
end
