require_relative '../acceptance_helper'

feature 'Search', '
  In order to find something
  As a user
  I want to be able to use search bar and see a result
' do

  given!(:question1) { create(:question, body: 'It is possible to find this question') }
  given!(:question2) { create(:question, title: 'Find is in the title') }
  given!(:question_not_found) { create(:question, body: 'Nothing interesting') }

  given!(:answer1) { create(:answer, body: 'You can find the word here') }
  given!(:answer2) { create(:answer, body: 'There is find') }
  given!(:answer_not_found) { create(:answer, body: 'No words I need') }

  given!(:comment_question) { create(:comment, commentable: question1, body: 'Comment to find') }
  given!(:comment_answer) { create(:comment, commentable: answer1, body: 'Try to find it') }
  given!(:comment_not_found) { create(:comment, body: 'Not useful') }

  given!(:user1) { create(:user, email: 'find@mail.com') }
  given!(:user2) { create(:user, email: 'mail@find.com') }
  given!(:user_not_found) { create(:user, email: 'my@mail.com') }

  given!(:question_cyrillic) { create(:question, body: 'Мой вопрос') }

  before do
    index
    visit root_path
  end

  context 'Search question', js: true do
    before do
      select 'questions', from: 'search-type'
    end

    scenario 'no results found' do
      fill_in 'search-bar', with: 'peekaboo'
      click_on 'Search'

      expect(page).to have_content '0 results'
      expect(find('#search-result').text).to be_empty
    end

    scenario 'entities are found', js: true do
      find('#search-bar').set('find')
      click_on 'Search'

      expect(page).to have_content '2 results'
      within '#search-result' do
        [question1, question2].each do |question|
          expect(page).to have_link(question.title, href: question_path(question))
          expect(page).to have_content(question.body)
        end
      end
    end
  end

  context 'Search answer', js: true do
    before do
      select 'answers', from: 'search-type'
    end

    scenario 'no results found' do
      fill_in 'search-bar', with: 'peekaboo'
      click_on 'Search'

      expect(page).to have_content '0 results'
      expect(find('#search-result').text).to be_empty
    end

    scenario 'entities are found', js: true do
      find('#search-bar').set('find')
      click_on 'Search'

      expect(page).to have_content '2 results'
      within '#search-result' do
        [answer1, answer2].each do |answer|
          expect(page).to have_link(answer.question.title, href: question_path(answer.question))
          expect(page).to have_content(answer.body)
        end
      end
    end
  end

  context 'Search comment', js: true do
    before do
      select 'comments', from: 'search-type'
    end

    scenario 'no results found' do
      fill_in 'search-bar', with: 'peekaboo'
      click_on 'Search'

      expect(page).to have_content '0 results'
      expect(find('#search-result').text).to be_empty
    end

    scenario 'entities are found', js: true do
      find('#search-bar').set('find')
      click_on 'Search'

      expect(page).to have_content '2 results'
      within '#search-result' do
        [comment_answer, comment_question].each do |comment|
          expect(page).to have_content(comment.body)
        end
        expect(page).to have_link(
          comment_question.commentable.title,
          href: question_path(comment_question.commentable)
        )
        expect(page).to have_link(
          comment_answer.commentable.question.title,
          href: question_path(comment_answer.commentable.question)
        )
      end
    end
  end

  context 'Search user', js: true do
    before do
      select 'users', from: 'search-type'
    end

    scenario 'no results found' do
      fill_in 'search-bar', with: 'peekaboo'
      click_on 'Search'

      expect(page).to have_content '0 results'
      expect(find('#search-result').text).to be_empty
    end

    scenario 'entities are found', js: true do
      find('#search-bar').set('find')
      click_on 'Search'

      expect(page).to have_content '2 results'
      within '#search-result' do
        [user1, user2].each do |user|
          expect(page).to have_content(user.email)
        end
      end
    end
  end

  context 'Search everywhere', js: true do
    before do
      select 'everywhere', from: 'search-type'
    end

    scenario 'no results found' do
      fill_in 'search-bar', with: 'peekaboo'
      click_on 'Search'

      expect(page).to have_content '0 results'
      expect(find('#search-result').text).to be_empty
    end

    scenario 'entities are found', js: true do
      find('#search-bar').set('find')
      click_on 'Search'

      expect(page).to have_content '8 results'
      within '#search-result' do
        [question1, question2].each do |question|
          expect(page).to have_link(question.title, href: question_path(question))
          expect(page).to have_content(question.body)
        end
        [answer1, answer2].each do |answer|
          expect(page).to have_link(answer.question.title, href: question_path(answer.question))
          expect(page).to have_content(answer.body)
        end
        [comment_answer, comment_question].each do |comment|
          expect(page).to have_content(comment.body)
        end
        expect(page).to have_link(
          comment_question.commentable.title,
          href: question_path(comment_question.commentable)
        )
        expect(page).to have_link(
          comment_answer.commentable.question.title,
          href: question_path(comment_answer.commentable.question)
        )
        [user1, user2].each do |user|
          expect(page).to have_content(user.email)
        end
      end
    end
  end

  scenario 'Search using cyrrilic query', js: true do
    find('#search-bar').set('Мой вопрос')
    click_on 'Search'

    expect(page).to have_content '1 results'
  end
end
