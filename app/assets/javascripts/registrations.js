$(document).ready(function() {
  console.log('new JS is running');
  $('#organization').change(function(){
    var orgName = $("select option:selected").first().text()
    $.ajax({
      url: '/get_locations',
      method: 'get',
      data: {
        organization: orgName
      },
      datatype: 'json'
    }).done(function(data){
      console.log(data);
      $('#location_id').empty();
        for (i = 0; i < data.length; i++){
          $('#location_id').append(
            $('<option></option>').attr('value',data[i].id).text(data[i].branch_name)
          )
        }
      $('select').material_select();
    }).fail(function(data){
      console.log('AJAX has failed');
      console.log(data);
    });
  });
})
