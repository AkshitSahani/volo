$(document).ready(function() {
  console.log('this JS is running');
  $('#user_account_type').change(function(){
    if ($( "select option:selected" ).first().text() == "Organization") {
      console.log("A");
      if ($('#first_name_label').html() == 'First Name') {
        console.log("B");
        $('#first_name_label').html('Organization Name');
        $('#last_name').remove();
        $('#birthdate').remove();
        var addressDiv = $('<div>').addClass('field').attr('id', 'org_address');
        var inputAddress = $('<input></input>').attr('type','text').attr('name','organization[address]').attr('id', 'org_address_input');
        var labelAddress = $('<label></label>').attr('id', 'org_address_label').attr('for', 'org_address').html('Head Office Full Address');
        addressDiv = $(addressDiv).append(labelAddress).append(inputAddress);
        $('#first_name_label').parent().after(addressDiv);
      }
      else {
        console.log("C");
        $('#first_name_label').html('First Name');
        var lastNameDiv = $('<div>').addClass('field').attr('id','last_name');
        var inputLastName = $('<input></input>').attr('type','text').attr('name','user[last_name]').attr('id', 'last_name_input');
        var labelLastName = $('<label></label>').attr('id', 'last_name_label').attr('for', 'user_last_name').html('Last Name');
        lastNameDiv = $(lastNameDiv).append(labelLastName).append(inputLastName);
        $('#first_name_label').parent().after(lastNameDiv);
        $('#org_address').remove();
        var birthdateDiv = $('<div>').addClass('field').attr('id','birthdate');
        var inputBirthdate = $('<input></input>').attr('type','date').attr('name','user[birthdate]').attr('id', 'birthdate_input');
        var labelBirthdate = $('<label></label>').attr('id', 'birthdate_label').attr('for', 'user_birthdate').html('Date Of Birth');
        birthdateDiv = $(birthdateDiv).append(labelBirthdate).append(inputBirthdate);
        $('#phonenumber').after(birthdateDiv);
      }
    }
    else if ($( "select option:selected" ).first().text() == "Volunteer") {
      console.log("D");
      if ($('#first_name_label').html() != 'First Name') {
        console.log("E");
        $('#first_name_label').html('First Name');
        var lastNameDiv = $('<div>').addClass('field').attr('id','last_name');
        var inputLastName = $('<input></input>').attr('type','text').attr('name','user[last_name]').attr('id', 'last_name_input');
        var labelLastName = $('<label></label>').attr('id', 'last_name_label').attr('for', 'user_last_name').html('Last Name');
        lastNameDiv = $(lastNameDiv).append(labelLastName).append(inputLastName);
        $('#first_name_label').parent().after(lastNameDiv);
        $('#org_address').remove();
        var birthdateDiv = $('<div>').addClass('field').attr('id','birthdate');
        var inputBirthdate = $('<input></input>').attr('type','date').attr('name','user[birthdate]').attr('id', 'birthdate_input');
        var labelBirthdate = $('<label></label>').attr('id', 'birthdate_label').attr('for', 'user_birthdate').html('Date Of Birth');
        birthdateDiv = $(birthdateDiv).append(labelBirthdate).append(inputBirthdate);
        $('#phonenumber').after(birthdateDiv);
      }
    }
    else if ($( "select option:selected" ).first().text() == "Resident") {
      console.log("E");
      if ($('#first_name_label').html() != 'First Name') {
        console.log("E");
        $('#first_name_label').html('First Name');
        var lastNameDiv = $('<div>').addClass('field').attr('id','last_name');
        var inputLastName = $('<input></input>').attr('type','text').attr('name','user[last_name]').attr('id', 'last_name_input');
        var labelLastName = $('<label></label>').attr('id', 'last_name_label').attr('for', 'user_last_name').html('Last Name');
        lastNameDiv = $(lastNameDiv).append(labelLastName).append(inputLastName);
        $('#first_name_label').parent().after(lastNameDiv);
        $('#org_address').remove();
        var birthdateDiv = $('<div>').addClass('field').attr('id','birthdate');
        var inputBirthdate = $('<input></input>').attr('type','date').attr('name','user[birthdate]').attr('id', 'birthdate_input');
        var labelBirthdate = $('<label></label>').attr('id', 'birthdate_label').attr('for', 'user_birthdate').html('Date Of Birth');
        birthdateDiv = $(birthdateDiv).append(labelBirthdate).append(inputBirthdate);
        $('#phonenumber').after(birthdateDiv);
      }
    };
  });
})
