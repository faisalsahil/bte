$(document).ready(function(){
    $('.list-data-table').DataTable({
        "pageLength": 50
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
        $('#route_area').append('<select name="route[area_ids][]" id="route_area_id" multiple="multiple"></select>');
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