$(function() {

	var CLS = {
		hide: 'hideable',
		run: 'run',
		sample: 'sample',
		syntax: 'rainbow',
		opened: 'opened'
	}
	var EL = {
	
	}

	function cancel(e) {
		e.preventDefault();
	}

	function get(e) {
		cancel(e)
		var el    = $(this)
		var p     = el.closest('.api')
		var code  = $('.'+ CLS.sample +' code', p)
		var hide  = code.closest('.'+ CLS.hide)
		var z_key = 'z_key='+ $.trim($('#key input').val())
		var url   = el.attr('href') +'?'+ z_key
		var isrun = el.is('.run')

		if (isrun)
			el.html('<img src="/i/loader.gif" width=14 height=14 />...')

		hide.slideUp(200)
		$.get(url, function(json_text) {
			code.removeClass(CLS.syntax)
			code[0].innerHTML = json_text

			Rainbow.color()
			keyChange()
			hide.slideDown(200)
			EL.search = $('#search .search')
			if (isrun)
				el.html(el.data('loader'))
		})
	}
	
	function closer() {
		$(this).closest('.'+ CLS.hide).slideUp(200)
	}

	function source() {
		var el = $(this)	
		var opened = el.hasClass(CLS.opened)
		if (opened)
			el.removeClass(CLS.opened)
		else
			el.addClass(CLS.opened)
	}


	function term(command, term) {
		if (command === '') return term.echo('')
		try { termGet(command, term) }
		catch(e) { term.echo(e) }
	}

	function termGet(command, term) {
		var args   = command.split(' ')
		var action = args.shift()
		var z_key  = $('#key input').val()

		args = args.join(' ')

		var params = {
			action: $.trim(action),
			args:   $.trim(args),
			z_key:  $.trim(z_key)
		}

		$('#term .prompt').hide();
		term.echo('Running '+ params.action +'...')
		$.get('/term', params, function(out) {
			term.echo(out)
			$('#term .prompt').show()
		})
	}

	function startTerm() {
		window.t = $('#term').terminal(term, {
			greetings: 'Zirrow is ready...',
			height:    300,
			prompt:    '@z.',
			onFocus: function(cur) {
				window.t.enable()
				$(window).one('click', function() {
					window.t.disable();
				})
			}
		})

	}

	function toggleTerm(e) {
		cancel(e)
		startTerm()
		if (window.t.is(':visible')) {
			window.t.slideUp(150).blur()
			$('#begin').slideDown(150);
			$(this).html('Run Terminal &raquo;')	
			return 
		}
		$('#begin').slideUp(150);
		window.t.slideDown(150).focus()
		$('#term').focus()
		$(this).html('Hide Terminal &raquo;')	
	}

	function afterLoad() {
		EL.search = $('#search .search')
		Rainbow.color()
		window._list = new List('apis', {
			valueNames: ['desc']	
		})
	}

	function loadup(html) {
		var apis = $('#apis')
		apis.fadeOut(200, function() {
			apis[0].innerHTML = html	
			afterLoad()
			apis.fadeIn(50)	
			$('#top').show()
			keyChange()
		})
	}

	function getkey(e) {
		var tar = $(e.target)
		if (tar.is('textarea') || tar.is('body')) {
			var text = getPromptVal()
			if (!text.length) {
				EL.search.val('')
				window._list.search('')
				return
			}
			a = text.split('&nbsp;')

			if (e.which == 8) 
				a[0] = a[0].slice(0, -1)
			EL.search.val(a[0])
			window._list.search(a[0])
		}
	}

	function getPromptVal() {
		return $('#term .prompt').next().html()
	}

	function setPromptVal(val) {
		var p = $('#term .prompt').next()
		var t = $.trim(p.text())
		if (t.length) return
		p.text($.trim(val) +' ')
	}

	function searchVal(text) {
		EL.search.val(text)
		window._list.search(text)
		setPromptVal(text)
	}

	function speech() {
		text = EL.search.val()
		text = text.split(' ')
		if (!text.length) return
		searchVal(text[0])
	}

	function getFauxKey() {
		return $.Event('keyup', {'keycode': 40, 'which': 40})	
	}

	function init() {
		$.get('/apis', loadup).error(init)
	}

	function toTop(e) {
		cancel(e)	
		$('html, body').animate({
			scrollTop: 0
		}, 650);
	}

	function keyChange() {
		var val = $('#key input').val()
		$('#begin').find('code .string:last').text("'"+ val +"'")		
	}

	// DOIT
	EL.m      = $('#main')
	EL.search = false
	window.t  = null;

	EL.m.on('click', '.api a, .api .run', get)
	 .on('click', '.hide', closer)
	 .on('click', '.source', source)
	 .on('click', '#termtoggle', toggleTerm)
	 .on('webkitspeechchange', '#search .search', speech)
	 .on('click', '#top', toTop)
	 .on('change', 'input[name="z_key"]', keyChange)
	 
	$(document).keyup(getkey)

	init();
})
