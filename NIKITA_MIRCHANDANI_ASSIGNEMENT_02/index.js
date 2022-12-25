function reset(){
    var element = document.getElementById("patientDetailsForm");
    // console.log("done"); 
    element.reset();
}
function ageCalculator() {
    
  var userinput = document.getElementById("DOB").value;
  var dob = new Date(userinput);
    
  
    if(userinput==null || userinput==''){
      document.getElementById("message").innerHTML = "**Choose a date please!";  
      return false; 
    }else {
    var dobYear = dob.getYear();
    var dobMonth = dob.getMonth();
    var dobDate = dob.getDate();

    var now = new Date();//current date
    var currentYear = now.getYear();
    var currentMonth = now.getMonth();
    var currentDate = now.getDate();
	
    //declare a variable to collect the age in year, month, and days
    var age = {};
    var ageString = "";
  
    //get years
    yearAge = currentYear - dobYear; //2022-2002 =20
	
    //get months : 12 < 13 
    if (currentMonth >= dobMonth)
      var monthAge = currentMonth - dobMonth; 
    else {
      yearAge--; //19
      var monthAge = 12 + currentMonth - dobMonth; //12+12-
    }

    //get days:12>10
    if (currentDate >= dobDate) 
      var dateAge = currentDate - dobDate; //2
    else {
      monthAge--;
      var dateAge = 31 + currentDate - dobDate;

      if (monthAge < 0) {
        monthAge = 11;
        yearAge--;
      }
    }
    //group the age in a single variable
    age = {
    years: yearAge,
    months: monthAge,
    days: dateAge
    };
      
      
    if ( (age.years > 0) && (age.months > 0) && (age.days > 0) )
       ageString = age.years + " Y, " + age.months + " M, " + age.days + " D";
    else if ( (age.years == 0) && (age.months == 0) && (age.days > 0) )
       ageString = age.days + " D";
    //when current month and date is same as birth date and month
    else if ( (age.years > 0) && (age.months == 0) && (age.days == 0) )
       ageString = age.years +  " Y";
    else if ( (age.years > 0) && (age.months > 0) && (age.days == 0) )
       ageString = age.years + " Y " + age.months + " M";
    else if ( (age.years == 0) && (age.months > 0) && (age.days > 0) )
       ageString = age.months + " M " + age.days + " D";
    else if ( (age.years > 0) && (age.months == 0) && (age.days > 0) )
       ageString = age.years + " Y " + age.days + " D";
    else if ( (age.years == 0) && (age.months > 0) && (age.days == 0) )
       ageString = age.months + " M";
    //when current date is same as dob(date of birth)
    else ageString = "Welcome to Earth! <br> It's first day on Earth!"; 
    
    if(age.years < 18 ){
      document.getElementById("result").innerHTML = ageString; 
      console.log("Minor!!")
      alert("Please add Contact Detail for Patient as he/she is a minor!")
    }
    document.getElementById("result").innerHTML = ageString; 
             
  }
}
  const form = document.getElementById("patientDetailsForm");

  form.addEventListener('submit', (e) => {
    e.preventDefault(); 
    const formData = new FormData(form); // Converts to array of arrays
    const entries = formData.entries()
    const obj = Object.fromEntries(entries); // Array of arrays to object
    console.log(obj);
  });
  
var coll = document.getElementsByClassName("collapsible");
var i;

for (i = 0; i < coll.length; i++) {
  coll[i].addEventListener("click", function() {
    this.classList.toggle("active");
    // var content = document.getElementsByClassName("expandle-details");
    var content = this.parentElement.nextElementSibling;
    console.log("prinitng.."+content);
    if (content.style.display === "block") {
      content.style.display = "none";
      // document.getElementsByClassName("profile1").style.border = "1px solid rgb(216, 214, 233);";
      
     } else {
       // set border of other details title h4
      content.style.display = "block";
      // document.getElementsByClassName("profile1").style.border = "1px solid rgb(216, 214, 233);";
      
    }
  });
}
const sidebar = document.querySelector('.sidebar');
const mainContent = document.querySelector('.Patient-details')
const rightbutton = document.querySelector('.sidebar-arrow')
const arrowleft = rightbutton.querySelector('.fa-sharp.fa-solid.fa-angle-left')
console.log(arrowleft);
document.querySelector('.sidebar-arrow').onclick = function () {
  sidebar.classList.toggle('sidebar_small');
  mainContent.classList.toggle('Patient-details_large');
  arrowleft.classList.toggle('fa-sharp.fa-solid.fa-angle-right');
}

 
// var col = document.getElementsByClassName("phone-add");
// var i;

// for (i = 0; i < col.length; i++) {
//    col[i].addEventListener("click", function() {
//     this.classList.toggle("active");
//     var content = this.parentElement.nextElementSibling;
//     if (content.style.display === "block") {
//       content.style.display = "none";
//      } else {
//       content.style.display = "block";
//     }
//   });
// }
var ct = 1;
function add_phone_icon()
{
	ct++;
	var div1 = document.createElement('div');
	div1.id = ct;
	// link to delete extended form elements
  var delLink = '<div style="width:250px;direction: rtl;margin: 5px;"><button type-"button" onclick="delIt('+ ct +')"><i class="fa-solid fa-trash"  style="color: #627d98;"></i></button></div>';
	// var delLink = '<div style="text-align:right;margin-right:65px"><a href="javascript:delIt('+ ct +')">Del</a></div>';
	div1.innerHTML = document.getElementById('newadd-phone-template').innerHTML + delLink;
	document.getElementById('add-phone-template').appendChild(div1);
}

function delIt(eleId)
{
	d = document;
	var ele = d.getElementById(eleId);
	var parentEle = d.getElementById('add-phone-template');
	parentEle.removeChild(ele);
}
