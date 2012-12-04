$(function() {
	var m = $('#main')

	function get(e) {
		e.preventDefault();
		var el    = $(this)
		var p     = el.closest('.api')
		var code  = $('.sample code', p)
		var hide  = code.closest('.hideable')
		var z_key = 'z_key='+ $('#key input').val()
		var url   = el.attr('href') +'?'+ z_key

		hide.slideUp(200)
		$.get(url, function(json_text) {
			code.removeClass('rainbow')
			code[0].innerHTML = json_text
			Rainbow.color()
			hide.slideDown(200);
		})
	}
	
	function closer() {
		var el = $(this)
		el.closest('.hideable')
		  .slideUp(200)
	}

	function source() {
		var el = $(this)	
		var opened = el.hasClass('opened')
		if (opened)
			el.removeClass('opened')
		else
			el.addClass('opened')
	}

	m.on('click', '.api a', get)
	 .on('click', '.hide', closer)
	 .on('click', '.source', source)
})
