document.addEventListener('turbolinks:load', function () {

  let ratingLinks = document.querySelectorAll('.rating-link');

  if (ratingLinks) {

    ratingLinks.forEach((link) => {

      link.addEventListener('ajax:success', (e) => {
        let data = e.detail[0]
        let rating_field = 'rating_' + data.type
        document.getElementById(rating_field).innerText = data.rating;
      })
    })
  }
})
