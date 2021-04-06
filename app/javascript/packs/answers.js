$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', editAnswer )
  $('.new-answer').on('ajax:success', answer_update)
                  .on('ajax:error', errors_output)
})

function editAnswer(event){
 event.preventDefault()

 $(this).hide()
 let answerId = $(this).data('answerId')
 $('form#edit-answer-' + answerId).removeClass('hidden')
}

function answer_update(e) {
  let answer = e.detail[0]
  $('.answers').append('<p>' + answer.body + '</p>')
}

function errors_output(e) {
  let errors = e.detail[0]
  $.each(errors, function(index, value) {
    $('.answer-errors').append('<p>' + value + '</p>')
  })
}
