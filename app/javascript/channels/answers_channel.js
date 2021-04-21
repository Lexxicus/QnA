import consumer from "./consumer";

$(document).on('turbolinks:load', function () {
  if (/questions\/\d+/.test(window.location.pathname)) {
    consumer.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
      received(data){

        if (gon.current_user_id != data.answer.user_id){
          let result = this.createTemplate(data)
          $('.answers').append(result)
        }
      },

      createTemplate(data){
        let result =  `
        <div class = "card">
          <div class = "answer-${data.answer.id}">
            <p> ${data.answer.body}</p>
            <p> Rating: 0 </p>
          </div>
        </div>
        `
        $.each(data.links, function(index, value) {
          result += `<a href = ${value.url}> ${value.name} </a>`
        })

        return result
      }
    })
  }
})
