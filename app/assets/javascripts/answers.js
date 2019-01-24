$(document).on('turbolinks:load', function(){
   $('.answers').on('click', '.edit-answer-link', function(e) {
       e.preventDefault();
       $(this).hide();
       var answerId = $(this).data('answerId');
       console.log(answerId);
       $('form#edit-answer-' + answerId).removeClass('hidden');
   })
});

function checkBest(currentAnswer, currentAnswerBest) {
  
  if (currentAnswerBest) {
    loserAnswer = $('.answer.best');
    if (loserAnswer.length) {
      makeLoser(loserAnswer);
    };
    makeBest(currentAnswer);
  } else {
    makeLoser(currentAnswer);
  };

  lift();

  function makeBest(answer) {
    answer.addClass("best");
    answer.children('.best-sign').removeClass("hidden");
  };

  function makeLoser(answer) {
    answer.removeClass("best");
    answer.children('.best-sign').addClass("hidden");
  };

  function lift() {
    bestAnswer = $('.answer.best');
    if (bestAnswer.length && (bestAnswer != $( ".answer:first"))) {
      $( ".answers" ).prepend(bestAnswer);
    }
  };

};

function moveBadge(placeForBadge) {
  badgeQuestionPlace = $(".badge_question_place");
  badge = $('.badge');
  
  if (badge.parent()[0] == badgeQuestionPlace[0]) {
    placeForBadge.append(badge);
  }  
};

