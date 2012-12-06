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
		var isrun = el.is('.run')

		if (isrun)
			el.html('<img src="/i/loader.gif" width=14 height=14 />...')

		hide.slideUp(200)
		$.get(url, function(json_text) {
			code.removeClass('rainbow')
			code[0].innerHTML = json_text
			Rainbow.color()
			hide.slideDown(200)
			if (isrun)
				el.html(el.data('loader'))
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

	function loadup(html) {
		var apis = $('#apis')
		apis.fadeOut(200, function() {
			apis[0].innerHTML = html	
			afterLoad()
			apis.fadeIn(50)	
		})
	}

	function afterLoad() {
		Rainbow.color()
		new List('apis', {
			valueNames: ['desc']	
		})
	}

	m.on('click', '.api a, .api .run', get)
	 .on('click', '.hide', closer)
	 .on('click', '.source', source)

	$.get('/apis', loadup)
})
