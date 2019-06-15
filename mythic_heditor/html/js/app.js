window.addEventListener("message", function (event) {
    if (event.data.action == "display") {
        $('.wrapper').html("");
        console.log(event.data.handling.length);
        $.each(event.data.handling, function (index, field) {
            $('.wrapper').append($('.template').clone());
            $('.wrapper').find('.handling-field:last-child').find('label').attr('for', field.name);
            $('.wrapper').find('.handling-field:last-child').find('label').html(field.name)
            $('.wrapper').find('.handling-field:last-child').find('input').attr('id', field.name);
            $('.wrapper').find('.handling-field:last-child').find('input').val(field.value);
            $('.wrapper').find('.handling-field:last-child').find('input').data('index', field.index);
            $('.wrapper').find('.handling-field:last-child').find('input').numeric();
            $('.wrapper').find('.handling-field:last-child').removeClass('template');
        });

        $('.wrapper').show();
    }
});


$( function() {
    document.onkeyup = function ( data ) {
        if ( data.which == 27 ) { // Escape key
            $('.wrapper').hide();
            $.post( "http://mythic_heditor/CloseUI", JSON.stringify());
        }
    };
    
    $('body').on( "focusout", "input.form-control", function() {
        console.log($(this).data('index') + " " + $(this).attr('id') + " " + $(this).val());
        $.post("http://mythic_heditor/UpdateHandlingField", JSON.stringify({
            index: $(this).data('index'),
            field: $(this).attr('id'),
            value: $(this).val()
        }));
    });
})