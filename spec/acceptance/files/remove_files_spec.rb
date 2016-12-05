require_relative '../acceptance_helper'

feature 'Remove a file', '
  In order to change the history
  As a user
  I want to be able to remove files
' do

  context 'When authenticated' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'remove a file for my own answer', js: true do
      fill_in 'Add answer', with: 'My smart answer'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create Answer'
      find(:css, '.remove-attachment-link').trigger('click')

      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
