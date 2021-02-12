$( ".LigeroIconPicker" ).parent().append( "<div class=\"LigeroIconPickerImage\"></div>" );

$(".LigeroIconPickerImage").html("<i class=\""+$( ".LigeroIconPicker" ).val()+" fa-5x\"/>")

$(".LigeroIconPicker").on("change",(e)=> {
  
  $(".LigeroIconPickerImage").html("<i class=\""+e.target.value+" fa-5x\"/>")
});

