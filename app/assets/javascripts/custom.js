$(document).ready(function(){

  $(".fa.fa-cogs").click(function(){
    $(".modal.range-slider").modal();
  });

  $( "#range-slider" ).slider({
      range: "max",
      min: 100,
      max: 300,
      value: 50,
      slide: function( event, ui ) {
        $( "#amount span" ).text( ui.value );
      }
    });
  $("#apply-filter").click(function() {
    var deal_price = $("#amount span").text()
    $.ajax({
      type: "POST",
      url: "/home/filter",
      data: { deal_price: deal_price },
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      success: function(data){
        var container = $(".offers-content");
        container.empty();
        container.html(data);
      }
    });
    $.modal.close();
    });

  $(".email-form").submit(function(event){
    var email = $("form.email-form input[type=text]").val();

    $.ajax({
      type: "POST",
      url: "/add_email",
      data: { email: email },
      success: function(data){
        $(".subscription-info h3").html(data);
        $(".subscription-info").modal();
      }
    });

    event.preventDefault();
    });

  $("#close-subscription-info").click(function(){
    $.modal.close();
  });
});
