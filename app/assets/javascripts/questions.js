$(document).on('turbolinks:load', function(){
   questionsList = $('.questions-list')

   $('.edit-question-link').on('click', function(e) {
       e.preventDefault();
       $(this).hide();
       $('.question-form').removeClass('hidden');
   })

   $('a.like, a.dislike').on('ajax:success', function(e) {
       var scorePlace = e.target.parentNode.parentNode;
       var scoreBag = e.detail[0];
       scorePlace.getElementsByClassName('score')[0].innerHTML = scoreBag.score;
   })       

});


App.cable.subscriptions.create('QuestionsChannel', {
  connected: function() { 
    console.log('connected!');
    this.perform('follow');
    },
  received: function(data) {    
    questionsList.append(data);
  }
});
