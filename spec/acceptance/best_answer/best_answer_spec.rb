require_relative '../acceptance_helper'

feature 'Select the best answer', '
  In order to show people that the answer helped me
  As a user
  I want to be able to select the best answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, body: 'answer1') }
  given!(:answer2) { create(:answer, question: question, body: 'answer2') }

  context 'When authenticated' do
    background do
      sign_in(user)
    end

    scenario 'select the best answer', js: true do
      visit question_path(question)

      within("#answer_#{answer2.id}") do
        find(:css, '.best-answer-link').trigger('click')
        wait_for_ajax
      end

      best_class = 'best-answer-link-selected'
      expect(find("#best-answer-link-#{answer1.id}")['class']).to_not include(best_class)
      expect(find("#best-answer-link-#{answer2.id}")['class']).to include(best_class)
    end

    scenario 'unselect the best answer', js: true do
      best_answer = create(:answer, question: question, body: 'the best answer', best: true)

      visit question_path(question)
      within("#answer_#{best_answer.id}") do
        find(:css, '.best-answer-link').trigger('click')
        wait_for_ajax
      end

      expect(
        find("#best-answer-link-#{best_answer.id}")['class']
      ).to_not include('best-answer-link-selected')
    end

    scenario 'there can be only one best answer', js: true do
      best_answer = create(:answer, question: question, body: 'the best answer', best: true)

      visit question_path(question)
      within("#answer_#{answer2.id}") do
        find(:css, '.best-answer-link').trigger('click')
        wait_for_ajax
      end

      best_class = 'best-answer-link-selected'
      expect(find("#best-answer-link-#{answer1.id}")['class']).to_not include(best_class)
      expect(find("#best-answer-link-#{answer2.id}")['class']).to include(best_class)
      expect(
        find("#best-answer-link-#{best_answer.id}")['class']
      ).to_not include(best_class)
    end

    scenario 'only the author of the question can choose the best answer', js: true do
      question_other_user = create(:question)
      ans1 = create(:answer, question: question_other_user, body: 'answer1')
      ans2 = create(:answer, question: question_other_user, body: 'answer2')

      visit question_path(question_other_user)

      within("#answer_#{ans2.id}") do
        find(:css, '.best-answer-link').trigger('click')
        wait_for_ajax
      end

      best_class = 'best-answer-link-selected'
      expect(find("#best-answer-link-#{ans1.id}")['class']).to_not include(best_class)
      expect(find("#best-answer-link-#{ans2.id}")['class']).to_not include(best_class)
    end
  end

  context 'When unauthenticated' do
    scenario "don't see selected the best answer link", js: true do
      visit question_path(question)

      expect(page).to_not have_selector '.best-answer-link'
    end

    scenario 'see the sign of the best answer', js: true do
      best_answer = create(:answer, question: question, body: 'the best answer', best: true)

      visit question_path(question)

      expect(
        find("#best-answer-link-#{best_answer.id}")['class']
      ).to include('best-answer-link-selected')
    end
  end

  context 'Mulitple sessions', js: true do
    let(:another_user) { create(:user) }

    scenario "mark the best user's answer that appeared without refreshing" do
      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        fill_in 'Add answer', with: 'Added without page refresh'
        click_on 'Create Answer'
      end

      Capybara.using_session('user') do
        within all('.answer').last do
          find(:css, '.best-answer-link').trigger('click')
          wait_for_ajax
          expect(find('.best-answer-link')['class']).to include('best-answer-link-selected')
        end
      end
    end
  end
end
