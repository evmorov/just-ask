require_relative '../acceptance_helper'

feature 'Add files to answer', "
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Add files when posting an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Add answer', with: 'My smart answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Another file'
    within all('.attachment-fields').first do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    click_on 'Create Answer'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'Gemfile', href: '/uploads/attachment/file/1/Gemfile'
  end

  context 'Mulitple sessions', js: true do
    scenario "file of the other user's answer that appeared without refreshing" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Add answer', with: 'Added without page refresh'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Create Answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_link(
          'spec_helper.rb',
          href: '/uploads/attachment/file/1/spec_helper.rb'
        )
      end
    end
  end
end
