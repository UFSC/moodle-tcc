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
//= require bootstrap-alert
//= require bootstrap-modal
//= require bootstrap-tab
//= require bootstrap-transition
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.pt-BR
//= require ckeditor/init
//= require_tree .
//= require twitter/bootstrap/rails/confirm

$.fn.twitter_bootstrap_confirmbox.defaults = {
    fade: true,
    title: 'TCC UNA-SUS', // if title equals null window.top.location.origin is used
    cancel: "Não",
    proceed: "Sim",
    proceed_class: "btn proceed btn-primary"
};