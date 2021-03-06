$(document).on('turbolinks:load', function(){
   
   startSubsriptions();

   $('.edit-question-link').on('click', function(e) {
       e.preventDefault();
       $(this).hide();
       $('.question-form').removeClass('hidden');
   })
   
   $('a.like, a.dislike').on('ajax:success', scoreCounter);

});

function scoreCounter(e) {
  var scorePlace = e.target.parentNode.parentNode;
  var scoreBag = e.detail[0];
  scorePlace.getElementsByClassName('score')[0].innerHTML = scoreBag.score;
}

function startSubsriptions() {
  pathname = document.location.pathname
  
  if (pathname == '/' || pathname == '/questions') {
    startQuestionsChannelSub();
  };

  if (/\/questions\/\d+/.test(pathname)) {  
    startAnswersChannelSub();
    startCommentsChannelSub();
  };
}

function startQuestionsChannelSub() {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() { 
      console.log('Questions channel connected.');
      this.perform('follow');
      },
    received: function(data) {    
      questionsList = $('.questions-list');
      questionsList.append(JST["templates/question"]({ question: data.question }));
    }
  });
}

function startAnswersChannelSub() {
  App.cable.subscriptions.create({channel: 'AnswersChannel', id: gon.question_id}, {
    connected: function() { 
      console.log('Answer channel connected.');
      this.perform('follow');
      },
    received: function(data) { 
            
      if (data['answer'].author_id != gon.user_id) {
        answersList = $('.answers');
        answersList.append(JST["templates/answer"]({ answer: data.answer,
                                                     files: data.files,
                                                     links: data.links  }));
        answerClass = '.answer_'+ data.answer.id
        $(answerClass + ' a.like,' + answerClass + ' a.dislike').on('ajax:success', scoreCounter);
      }
    }
  });
}

function startCommentsChannelSub() {
  App.cable.subscriptions.create({channel: 'CommentsChannel', id: gon.question_id}, {
    connected: function() { 
      console.log('Comments channel connected.');
      this.perform('follow');
      },
    received: function(data) { 
                  
      if (data.comment.author_id != gon.user_id) {
                
        if (data.comment.commentable_type == "Question") {
          list = $('.question .comments');
        };

        if (data.comment.commentable_type == "Answer") {          
          list = $('.answer_'+ data.comment.commentable_id + ' .comments');
        };        
        list.append(JST["templates/comment"]({ comment: data.comment }));        
      }
    }
  });
}
