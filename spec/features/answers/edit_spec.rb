feature 'User can edit answer', %q{
  In order to correct mistake in answer
  As an authenticated user
  I'd like to be able to edit answer
} do

  given(:question) { create(:question, :with_answers) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background do
      question.answers.first.update(user_id: user.id)
      sign_in(user)
    end

    scenario 'edits his question' do
      visit question_path(question)
      click_on 'Edit answer'
      fill_in 'Body', with: 'text text text?'
      click_on 'Edit'

      expect(page).to have_content 'Your answer was successfully edited.'
      expect(page).to have_content 'text text text?'
    end

    scenario "edits question with errors" do
      visit question_path(question)
      click_on 'Edit answer'
      fill_in 'Body', with: ''
      click_on 'Edit'

      expect(page).to have_content "Body can't be blank"
    end

    scenario "edits not his answer" do
      visit question_path(question)
      click_on 'Edit answer'
      expect(page).to have_content "You can't edit/delete someone else's answer"
    end
  end

  context 'Unauthenticated user' do
    scenario "edits question" do
      visit question_path(question)
      click_on 'Edit answer'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end