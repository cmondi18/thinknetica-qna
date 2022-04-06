feature 'User can delete question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to delete question
} do

  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:another_question) { create(:question) }

    background do
      question.update(user_id: user.id)
      sign_in(user)
    end

    scenario 'deletes his question' do
      visit question_path(question)
      click_on 'Delete question'
      expect(page).to have_content 'Question was successfully deleted'
    end

    scenario "deletes not his question" do
      visit question_path(another_question)
      click_on 'Delete question'
      expect(page).to have_content "You can't edit/delete someone else's question"
    end
  end

  context 'Unauthenticated user' do
    scenario "deletes question" do
      visit question_path(question)
      click_on 'Delete question'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end