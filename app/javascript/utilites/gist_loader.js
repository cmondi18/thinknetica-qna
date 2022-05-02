import gistLoader from "easy-gist-async";

document.addEventListener('turbolinks:load', function () {
    gistLoader();

    var answerSubmitButton = document.querySelector('.new-answer input[type="submit"]');
    if (answerSubmitButton) answerSubmitButton.addEventListener('click', loadGist)
});


// I'm not sure that it is best option, but it works.
function loadGist() {
    setTimeout(() => { gistLoader(); }, 1000);
}
