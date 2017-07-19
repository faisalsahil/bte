$(document).ready(function(){
    $('.list-data-table').DataTable({
        "pageLength": 50,
        "aaSorting": [[ 0, "asc" ]]
    });

    // branches index
    $('#branches_index_table').DataTable({
        "lengthMenu": [ [-1, 50, 25, 10], ["All", 50, 25, 10] ],
        "aaSorting": [[ 1, "asc" ]]
        // "fnDrawCallback": function(){
        //     console.log("fnDrawCallback");
        // }
    });

    $('#branches').sortable({
        axis: 'y',
        handle: '.handle',
        update: function () {
            $.ajax({
                url: '/route_branches/sort',
                dataType:'JSON',
                type: 'post',
                data: $(this).sortable('serialize'),
                success:function(data){
                },
                error:function(){
                    //if there is an error append a 'none available' option
                    // $select.html('<option id="-1">none available</option>');
                }
            });
        }
    });

    $("#area_state_id").change(function(){
        var state_id = $("#area_state_id").val();
        $("#area_city_id").addClass('hidden');
        $select = $("#area_city_id");
        $select.html('');
        if (state_id > 0)
        {
            $.ajax({
                url: '/states/'+ state_id +'/cities/get_state_cities',
                dataType:'JSON',
                success:function(data){
                    if (data.status == true)
                    {
                        $select = $("#area_city_id");
                        $select.html('');
                        // $select.html('<option value = "-1">Select city</option>');
                        $.each(data.cities, function(key, val){
                            $select.append('<option value="' + val.id + '" name="' + val.id + '" >' + val.name + '</option>');
                        })
                        $("#area_city_id").removeClass('hidden');
                    }else
                    {
                        $select = $("#area_city_id");
                        $select.html('');
                        $select.html('<option value = "-1">Select user</option>');
                        $("#area_city_id").removeClass('hidden');
                    }
                },
                error:function(){
                }
            });
        }
    });

    //New branch page
    $("#branch_state_id").change(function(){
        var state_id = $("#branch_state_id").val();
        $('#branch_street').addClass('hidden');
        $('#branch_zip').addClass('hidden');
        $("#branch_area_id").addClass('hidden');
        $select = $("#branch_area_id");
        $select.html('');

        $("#branch_city_id").addClass('hidden');
        $select = $("#branch_city_id");
        $select.html('');
        if (state_id > 0)
        {
            $.ajax({
                url: '/states/'+ state_id +'/cities/get_state_cities',
                dataType:'JSON',
                success:function(data){
                    if (data.status == true)
                    {
                        $select = $("#branch_city_id");
                        $select.html('');
                        $select.html('<option value = "-1">Select city</option>');
                        $.each(data.cities, function(key, val){
                            $select.append('<option value="' + val.id + '" name="' + val.id + '" >' + val.name + '</option>');
                        })
                        $("#branch_city_id").removeClass('hidden');
                    }else
                    {
                        $select = $("#branch_city_id");
                        $select.html('');
                        $select.html('<option value = "-1">Select user</option>');
                        $("#branch_city_id").removeClass('hidden');
                    }
                },
                error:function(){
                }
            });
        }
    });

    $("#branch_city_id").change(function(){
        var city_id = $("#branch_city_id").val();
        $('#branch_street').addClass('hidden');
        $('#branch_zip').addClass('hidden');
        $("#branch_area_id").addClass('hidden');
        $select = $("#branch_area_id");
        $select.html('');
        if (city_id > 0)
        {
            $.ajax({
                url: '/cities/'+ city_id +'/get_city_areas',
                dataType:'JSON',
                success:function(data){
                    if (data.status == true)
                    {
                        $select = $("#branch_area_id");
                        $select.html('');
                        $select.html('<option value = "-1">Select area</option>');
                        $.each(data.areas, function(key, val){
                            $select.append('<option value="' + val.id + '" name="' + val.id + '" >' + val.name + '</option>');
                        })
                        $("#branch_area_id").removeClass('hidden');
                    }else
                    {
                        $select = $("#branch_area_id");
                        $select.html('');
                        $select.html('<option value = "-1">Select user</option>');
                        $("#branch_area_id").removeClass('hidden');
                    }
                },
                error:function(){
                }
            });
        }
    });

    $('#branch_area_id').change(function(){
        var branch = $(this).val();
        if(branch > 0 ){
            $('#branch_street').removeClass('hidden');
            $('#branch_zip').removeClass('hidden');

        }else{
            $('#branch_street').addClass('hidden');
            $('#branch_zip').addClass('hidden');
        }
    });

    $('.dropdown_easy_selection').multiselect({
        // includeSelectAllOption: true,
        enableFiltering: true,
        enableCaseInsensitiveFiltering: true,
        // enableClickableOptGroups: true,
        maxHeight: 200,
        buttonWidth: '200px'
    });

    // new route page
    $("#route_state_id").change(function(){
        var state_id = $("#route_state_id").val();
        $("#route_area").addClass('hidden');
        $('#route_area').html('');
        $("#select_branches").html('');

        $("#route_city_id").addClass('hidden');
        $select = $("#route_city_id");
        $select.html('');
        if (state_id > 0)
        {
            $.ajax({
                url: '/states/'+ state_id +'/cities/get_state_cities',
                dataType:'JSON',
                success:function(data){
                    if (data.status == true)
                    {
                        $select = $("#route_city_id");
                        $select.html('');
                        $select.html('<option value = "-1">Select city</option>');
                        $.each(data.cities, function(key, val){
                            $select.append('<option value="' + val.id + '" name="' + val.id + '" >' + val.name + '</option>');
                        })
                        $("#route_city_id").removeClass('hidden');
                    }else
                    {
                        $select = $("#route_city_id");
                        $select.html('');
                        $select.html('<option value = "-1">Select user</option>');
                        $("#route_city_id").addClass('hidden');
                    }
                },
                error:function(){
                }
            });
        }
    });

    $("#route_city_id").change(function(){
        var city_id = $("#route_city_id").val();
        $("#route_area").addClass('hidden');
        $('#route_area').html('');
        $('#route_area').append('<select name="route[areas][]" id="route_area_id" multiple="multiple"></select>');
        $("#select_branches").html('');

        if (city_id > 0)
        {
            $.ajax({
                url: '/cities/'+ city_id +'/get_city_areas',
                dataType:'JSON',
                success:function(data){
                    if (data.status == true)
                    {
                        $select = $("#route_area_id");
                        $select.html('');

                        $.each(data.areas, function(key, val){
                            $select.append('<option value="' + val.id + '" name="' + val.id + '" >' + val.name + '</option>');
                        });
                        $("#route_area").removeClass('hidden');
                        $('#route_area_id').multiselect({
                            includeSelectAllOption: true,
                            enableFiltering: true,
                            enableClickableOptGroups: true,
                            maxHeight: 200,
                            buttonWidth: '250px',
                            onChange: function(option, checked, select) {
                                load_branches($('#route_area_id').val());
                            },
                            onSelectAll: function(option, checked, select) {
                                load_branches($('#route_area_id').val());
                            },
                            onDeselectAll: function(option, checked, select) {
                                load_branches($('#route_area_id').val());
                            }
                        });

                    }else
                    {
                        $select = $("#route_area");
                        $select.html('');
                        $select.html('<option value = "-1">Select user</option>');
                        $("#route_area").addClass('hidden');
                    }
                },
                error:function(){
                }
            });
        }
    });

    $('#route_area_id').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        enableClickableOptGroups: true,
        maxHeight: 200,
        buttonWidth: '250px',
        onChange: function(option, checked, select) {
            load_branches($('#route_area_id').val());
        },
        onSelectAll: function(option, checked, select) {
            load_branches($('#route_area_id').val());
        },
        onDeselectAll: function(option, checked, select) {
            load_branches($('#route_area_id').val());
        }
    });

    // route submit form validation
    $('#route_submit_form').submit(function(event)
    {
        $this = $(this);
        var state = $("#route_state_id").val();
        var city  = $("#route_city_id").val();
        var area  = $("#route_area_id").val();
        var branches = $("#route_submit_form input:checkbox.check_box_input:checked").length;
        if(state > 0 && city > 0 && area && branches > 0)
        {console.log(status);
        }else{
            $('.route_submit_error_notification').removeClass('hidden') ;
            return false;
        }
        return true;
    });



    //assignment complete page
    $('.route_quantity').on("keyup", function(event) {
       if($(this).val().length > 0)
       {
          // $(this).next().attr('disabled', true);
          $(this).parent().children('.route_transfer_to').attr('disabled', true);
          $(this).parent().children('.route_remove').attr('disabled', true);
       }else{
           // $(this).next().removeAttr('disabled');
           $(this).parent().children('.route_transfer_to').removeAttr('disabled');
           $(this).parent().children('.route_remove').removeAttr('disabled');
       }
    });

    $(".route_remove").change(function() {
        if($(this).is(':checked')) {
            $(this).prev().prev().attr('disabled', true);
            $(this).prev().prev().prev().val('');
            $(this).prev().prev().prev().attr('disabled', true);
            $(this).next().val('');
            $(this).next().attr('disabled', true)
        }else{
            $(this).prev().prev().removeAttr('disabled');
            $(this).prev().prev().prev().removeAttr('disabled');
            $(this).next().removeAttr('disabled')
        }
    });

    $('#route_assignment_completion_form').submit(function(event)
    {
        var status = true
        $("tr.route_assignment_tr").each(function() {
            $this = $(this);
            var quantity = $this.find(".route_quantity").val().length;
            var transfer = $this.find(".route_transfer_to").val().length;
            var remove   = $this.find(".route_remove").is(":checked");
            var image    = $this.find(".route_image").val().length;
            if(transfer > 0 || remove == true )
            {}
            else if(quantity > 0 && image > 0)
            {
            }else{
                status = false;
                return false;
            }
        });

        if(status == false)
        {
            $('.route_assignment_error_notification').removeClass('hidden') ;
            return false;
        }else{
            return true;
        }
    });



    // Company create page===============================================
    $(".company_branch_input").change(function() {
        if(this.checked) {
            $('#company_branch_form').removeClass('hidden');
        }else{$('#company_branch_form').addClass('hidden');}

    });

    $('#company_branches_attributes_0_contact_same_as_above').change(function () {
        if(this.checked) {
            var name  = $('#company_contact_name').val();
            var email = $('#company_contact_email').val();
            var phone = $('#company_contact_phone').val();
            $('#company_branches_attributes_0_contact_name').val(name);
            $('#company_branches_attributes_0_contact_email').val(email);
            $('#company_branches_attributes_0_contact_phone').val(phone);
        }else{
            $('#company_branches_attributes_0_contact_name').val('');
            $('#company_branches_attributes_0_contact_email').val('');
            $('#company_branches_attributes_0_contact_phone').val('');
        }
    });
    //===================================================================


    //  branches index page==============================================
    $(".branch_change_status").change(function(){
        alert($(this));
        var branch_id = $(this).parent().parent().attr('id');
        var status    = $(this).val();
        $.ajax({
            url: '/branches/'+ branch_id +'/update_branch_status',
            dataType:'JSON',
            type: 'post',
            data:{
                status: status
            },
            success:function(data){
               location.reload();
            },
            error:function(){
            }
        });
    });

    $('#branches_index_table').on( 'draw.dt', function () {
        update_selectopt();
    });


    // Add assignment====================================================
    $('#assignment_route_id').change(function(){
        $('#route_branches_list').html('');
        var route_id = $(this).val();
        if (route_id > 0)
        {
            $.ajax({
                url: '/routes/'+ route_id + '/get_route_branches',
                dataType:'script',
                success:function(data){

                },
                error:function(){
                }
            });
        }
    });



    // Add Template =====================================================
    $('.wysihtml5').each(function(i, elem) {
        $(elem).wysihtml5(
            {'toolbar':
                {
                    'blockquote': false,
                    'html': true,
                    'image': true,
                    "size": 'sm',
                    "color": true
                }
            }
        );
    });


    // send email template ==============================================
    $('#select_branches_for_email').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        onChange: function(option, checked, select) {
            var client = $(option).val();
            if ( checked ){
                var html = "<span style='margin-right: 5px;' class='badge' id="+ client + ">" + $(option).text() + "</span>";
                $('#selected_clients').prepend(html);
                $('#sent_email_button').attr('disabled', false);
            }else{
                $('#'+  client + '').remove();
                if( $('#selected_clients').is(':empty') ){
                    $('#sent_email_button').attr('disabled', true);
                }
            }
        },
        onSelectAll: function() {
            $('#selected_clients').html('');
            $("#select_branches_for_email option").each(function()
            {
                var client = $(this).val();
                var html   = "<span class='badge' id="+ client + ">" + $(this).text() + "</span>";
                $('#selected_clients').prepend(html);
            });
            $('#sent_email_button').attr('disabled', false);
        },
        onDeselectAll: function() {
            $('#selected_clients').html('');
            $('#sent_email_button').attr('disabled', true);
        }
    });
    $('#send_clients').multiselect({
        includeSelectAllOption: true,
        enableFiltering: true,
        onChange: function(option, checked, select) {
            var client = $(option).val();
            if ( checked ){
                var html = "<span style='margin-right: 5px;' class='badge' id="+ client + ">" + $(option).text() + "</span>";
                $('#selected_clients').prepend(html);
                $('#sent_email_button').attr('disabled', false);
            }else{
                $('#'+  client + '').remove();
                if( $('#selected_clients').is(':empty') ){
                    $('#sent_email_button').attr('disabled', true);
                }
            }
        },
        onSelectAll: function() {
            $('#selected_clients').html('');
            $("#send_clients option").each(function()
            {
                var client = $(this).val();
                var html   = "<span class='badge' id="+ client + ">" + $(this).text() + "</span>";
                $('#selected_clients').prepend(html);
            });
            $('#sent_email_button').attr('disabled', false);
        },
        onDeselectAll: function() {
            $('#selected_clients').html('');
            $('#sent_email_button').attr('disabled', true);
        }
    });


    // factory assignments page
    $('#factory_assignment_completion_form').submit(function(event)
    {
        var status = true;
        $("tr.factory_assignment_tr").each(function() {
            $this = $(this);
            var branch_selection = $this.find(".factory_branch_select").is(":checked");
            var image            = $this.find(".route_image").val().length;
            if(branch_selection == false)
            {}
            else if(branch_selection == true && image > 0)
            {}
            else{
                status = false;
                return false;
            }
        });

        if(status == false)
        {
            $('.route_assignment_error_notification').removeClass('hidden') ;
            return false;
        }else{
            return true;
        }
    });

    $(".factory_branch_select").change(function() {
        if($(this).is(':checked')) {
            $(this).next().removeAttr('disabled');
            var quantity = parseInt($(this).attr('quantity'));
            $('#total_quantity').val(parseInt($('#total_quantity').val()) + quantity)

        }else{
            $(this).next().val('');
            $(this).next().attr('disabled', true);
            var quantity = parseInt($(this).attr('quantity'));
            $('#total_quantity').val(parseInt($('#total_quantity').val()) - quantity)
        }
    });

    $('#factory_collection_quantity').on("keyup", function(event) {
        if($(this).val().length > 0)
        {
            $('#factory_collection_form_submit_button').removeAttr('disabled');
        }else{
            $('#factory_collection_form_submit_button').attr('disabled', true);
        }
    });


    // report index page
    $('#report_type').change(function(){
        if($(this).val().length > 0)
        {
          $('#generate_report_button').removeAttr('disabled');
        }else{
          $('#generate_report_button').attr('disabled', true);
        }
    });

});

function load_branches(area_ids)
{
    $('#select_branches').html('');
    if (area_ids && area_ids.length > 0)
    {
        $.ajax({
            url: '/areas/get_area_branches',
            dataType:'script',
            data: {
                area_id: area_ids
            },
            success:function(data){

            },
            error:function(){
            }
        });
    }
}

