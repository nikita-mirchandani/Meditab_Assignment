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
var btn = document.getElementById("right-arrow-btn");
var i;

for (i = 0; i < coll.length; i++) {
  coll[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var content = this.parentElement.nextElementSibling;
    // console.log("prinitng.."+content);
    if (content.style.display === "block") {
      content.style.display = "none";
      btn.style.transform="rotate(360deg)"; 
     } else {
       content.style.display = "block";
      btn.style.transform="rotate(90deg)";
      
    }
  });
}
const sidebar = document.querySelector('.sidebar');
const mainContent = document.querySelector('.Patient-details')
var sidebar_btn = document.getElementById("sidebar-btn");

document.querySelector('.sidebar-arrow').onclick = function () {
  sidebar.classList.toggle('sidebar_small');
  mainContent.classList.toggle('Patient-details_large');
  sidebar_btn.style.transform="rotate(180deg)";
}

/* 
var ct = 1;
function add_phone_icon()
{
	ct++;
	var div1 = document.createElement('div');
	div1.id = ct;
	// link to delete extended form elements
  var delLink = '<div style="width:250px;direction: rtl;margin: 5px;"><button type-"button" id="deleteicon" onclick="delIt('+ ct +')"><i class="fa-solid fa-trash"  style="color: #627d98;"></i></button></div>';
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

var ct1 = 1;
function add_phone_icon2()
{
	ct1++;
	var div1 = document.createElement('div');
	div1.id = ct1;
	// link to delete extended form elements
  var delLink = '<div style="direction: rtl;"><button type-"button" id="deleteicon" onclick="delIt2('+ ct1 +')"><i class="fa-solid fa-trash"  style="color: #627d98;"></i></button></div>';
	// var delLink = '<div style="text-align:right;margin-right:65px"><a href="javascript:delIt('+ ct +')">Del</a></div>';
	div1.innerHTML = document.getElementById('newadd-phone-template2').innerHTML + delLink;
	document.getElementById('add-phone-template2').appendChild(div1);
}

function delIt2(eleId)
{
	d = document;
	var ele = d.getElementById(eleId);
	var parentEle = d.getElementById('add-phone-template2');
	parentEle.removeChild(ele);
}
*/

function add_fieldset(){
const htmldata = ` 
<div class="Twoforms">
<fieldset>
<legend>
    <select name="" id="">
        <option value="">Home</option>
        <option value="">Work</option>
    </select>
</legend>
<div class="address-field-header">
    <h3>Address</h3><button type="button" class="delete-details" onclick="delete_details(this)"><i class="fa-solid fa-trash"
    style="color: #627d98;"></i></button>
</div>
<label for="Street">Street</label><br />
<input type="text" id="streetwidth"><br />
<div id="sameline">
    <div class="block">
        <label for="zip">Zip</label><br />
        <input type="text" id="zip">
    </div>
    <div class="block">
        <label for="City">City</label><br />
        <input type="text" id="city">
    </div>
    <div class="block">
        <label for="State">State</label><br />
        <select id="state">
            <option value=""></option>
            <option value="(AL) ALABAMA">(AL) ALABAMA</option>
        </select>
    </div>

    <div class="block">
        <label for="Country">Country</label><br />
        <select id="country">
            <option value="US">US</option>
            <option value="PR">PR</option>
        </select>
    </div>
    <div id="delete"><i class="fa-solid fa-trash"
            style="color: #627d98;"></i></div>
</div>
<div class="phone">
<label> Phone <button class="phone-add" onclick="add_phone_icon(this)"> <i
            class="fa-solid fa-circle-plus"></i></button></label>

    <div class="phone-header">
        <p class="type">Type</p>
        <p class="code">Code</p>
        <p class="number">Number</p>
        <p class="">Ext</p>
    </div>
    <hr>
    <div class="phone-inputs-container">
        <div class="phone-inputs">
            <select name="type1" id="type1" class="type-input">
                <option value="Cell">Cell</option>
                <option value="Landline">Landline</option>
            </select>
            <select name="code1" id="code1" class="code-input">
                <option value="+1">+1</option>
                <option value="+91">+91</option>
            </select>
            <input type="text" name="number1" id="number1"
                class="number-input">
                <button class="phone-delete" type="button" onclick="delete_phone_details(this)" ><i class="fa-solid fa-trash"
                    style="color: #627d98;"></i></button>
                
        </div>  
    </div>
</div>
<label>Fax <i class="fa-solid fa-circle-plus"
        style="color: #627d98;"></i></label> <br />
<label>Email <i class="fa-solid fa-circle-plus"
        style="color: #627d98;"></i></label> <br />
<input type="text" id="streetwidth">
<div class="trash"><i class="fa-solid fa-trash" style="color: #627d98;"></i>
</div>
<br />
<label>Website <i class="fa-solid fa-circle-plus"
        style="color: #627d98;"></i></label> <br />
</fieldset>
</div>`
document.getElementById("address-container").innerHTML += htmldata;
}
function delete_details(deletebtn){
  deletebtn.closest(".Twoforms").remove();
}
function add_phone_icon(btn){
  const addphonedata=`<div class="phone-inputs">
  <select name="type1" id="type1" class="type-input">
      <option value="Cell">Cell</option>
      <option value="Landline">Landline</option>
  </select>
  <select name="code1" id="code1" class="code-input">
      <option value="+1">+1</option>
      <option value="+91">+91</option>
  </select>
  <input type="text" name="number1" id="number1"
      class="number-input">
      <button class="phone-delete" type="button" onclick="delete_phone_details(this)" ><i class="fa-solid fa-trash"
          style="color: #627d98;"></i></button>
</div>  `;

btn.closest('.phone').querySelector('.phone-inputs-container').innerHTML += addphonedata;
}
function delete_phone_details(deletebtn){
  deletebtn.closest('.phone-inputs').remove();
}