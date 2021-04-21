import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  if (/questions\/\d+/.test(window.location.pathname)) {

    consumer.subscriptions.create({channel: "CommentsChannel"}, {

      connected: function () {
        let question_id = gon.question_id;
        return this.perform('follow', { question_id: question_id});
      },

        received(data) {
          if (gon.current_user_id === data.comment.user_id) return;

          let id = data.comment.commentable_type.toLowerCase() + '_' + data.comment.commentable_id + '_comments'
          let result = this.createTemplate(data)
          document.getElementById(id).innerHTML += result
        },

        createTemplate(data){
          let result =  `
          <li id="comment_${data.comment.id}\">
            <div class='row small'>
              <div class='col-10'> ${ data.comment.body } </div>
              <div class='col-2 text-right'>${data.user} </div>
            </div>
          </li>
          `
          return result
        }
      }
    );
  }
});
