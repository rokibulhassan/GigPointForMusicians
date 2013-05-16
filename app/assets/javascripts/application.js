// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function () {
    if (window.location.hash == '#_=_') {
        window.location.hash = '';
        history.pushState('', document.title, window.location.pathname);
        e.preventDefault();
    }

    $('.datepicker').on('focus', function () {
        $(this).datepicker({ dateFormat: "yy-mm-dd", validateBeforeShow: true  });
    });

    $('.datetimepicker, [date-time-picker]').on('focus', function () {
        var dateFormat = $(this).attr('date-format') || "yy-mm-dd";
        $(this).datetimepicker({ dateFormat: dateFormat, ampm: true, timeFormat: "hh:mm TT", validateBeforeShow: true });
    });

    $("#gig_venue_attributes_address").autocomplete({
        minLength: 1,
        source: function (request, response) {
            $.ajax({
                url: "/venues/auto_complete_for_venues",
                dataType: "json",
                data: {term: request.term},
                success: function (data) {
                    response(data);
                }
            });
        },
        change: function (event, ui) {
            $.ajax({
                url: "/venues/populate_location_map",
                data: {venue_id: ui.item.id}
            });
        }
    });

});


