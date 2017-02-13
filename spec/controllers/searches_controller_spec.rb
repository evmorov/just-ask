require 'rails_helper'

describe SearchesController, type: :controller do
  %w(questions answers comments users everywhere).each do |search_action|
    context "GET ##{search_action}" do
      it "render #{search_action} template" do
        get search_action, params: { q: 'keyword' }
        expect(response).to render_template search_action
      end

      it 'redirects to root if there is no request word' do
        get search_action
        expect(response).to redirect_to root_path
      end
    end
  end
end
