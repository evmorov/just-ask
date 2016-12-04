require_relative '../acceptance_helper'

feature 'Add files to question', "
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
" do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Text', with: 'text text text'
  end

  scenario 'Add a file when ask question', js: true do
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post Your Question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'Add several files when asking a question', js: true do
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Another file'
    within all('.attachment-fields').first do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    click_on 'Post Your Question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'Gemfile', href: '/uploads/attachment/file/1/Gemfile'
  end
end
