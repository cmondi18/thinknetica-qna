feature 'User can delete question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to delete question
} do

  context 'Authenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario 'can delete his question'
    scenario "can't delete not his question"
  end

  context 'Unauthenticated user' do
    scenario "can't delete question"
  end
end