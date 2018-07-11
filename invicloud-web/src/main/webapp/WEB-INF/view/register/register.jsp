<%--
  Created by IntelliJ IDEA.
  User: 贺俞凯
  Date: 2018/7/10
  Time: 9:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/WEB-INF/base.jsp" %>
<html>
<head>
    <title>invicloud注册页面</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.js"></script>
</head>
<body>
<form id="registerForm">
    <div>
        <label for="userName">Enter user name: </label>
        <input type="text" name="userName" id="userName">
    </div>
    <div>
        <label for="userPassword">Enter your password: </label>
        <input type="text" name="userPassword" id="userPassword">
    </div>
    <div>
        <label for="userPasswordConfirm">Confirm your password: </label>
        <input type="text" name="userPasswordConfirm" id="userPasswordConfirm">
    </div>
    <div>
        <li>Choose your sex: </li>
        <input type="radio" name="sex" value="0"/>保密
        <input type="radio" name="sex" value="1" checked="checked"/>男
        <input type="radio" name="sex" value ="2"/>女
    </div>
    <div>
        <li>Choose your birth year: </li>
        <select id="birthYear"></select>
    </div>
    <div>
        <input id="imgfile" type="file" name="userUploadImg" onchange="changeImg()"/>
        <img id="imgid" height="200" width="200" src="${pageContext.request.contextPath}/static/images/initial.jpg" alt="userUploadImg"/>
    </div>
    <div>
        <label for="phoneNumber">Enter your phone number: </label>
        <input type="text" name="phoneNumber", id="phoneNumber">
    </div>
    <div>
        <button type="button" id="btn_submit" onclick="checkUser();">Submit</button>
    </div>



</form>

</body>
<script language="javascript" type="text/javascript">
    window.onload=function()
    {
        var myDate = new Date();
        var startYear = myDate.getFullYear()-80;//起始年份，允许80岁以内的人注册
        var endYear = myDate.getFullYear();//当前年份
        var obj= document.getElementById('birthYear');
        for(var i=startYear;i<=endYear;i++)
        {
            obj.options.add(new Option(i,i))
        }
        obj.options[obj.options.length-81].selected = 1;
    };
    function changeImg() {
        var file=$("#registerForm").find("input")[6].files[0];
        var reader = new FileReader();
        var imgFile;
        reader.onload=function(e) {
            imgFile = e.target.result;
            console.log(imgFile);
            $("#imgid").attr('src', imgFile);
        };
        reader.readAsDataURL(file);
    }
    function checkUser() {
        var userName = document.getElementById("userName").value;
        var password = document.getElementById("userPassword").value;
        var passwordConfirm = document.getElementById("userPasswordConfirm").value;
        var phoneNumber = document.getElementById("phoneNumber").value;

        var obj=document.getElementById("birthYear");
        var index=obj.selectedIndex;
        var valOfYear = obj.options[index].value;//获取birthYear里用户选择的年份

        if(userName == "")
        {
            alert("用户名不能为空");
            return false;
        }
        if(password ==""||passwordConfirm=="")
        {
            alert("密码不能为空");
            return false;
        }
        if(passwordConfirm!=password)
        {
            alert("两次密码输入不一致");
            return false;
        }
        if(phoneNumber =="")
        {
            alert("请输入联系方式");
            return false;
        }


        var info=
            {
                userName:$("#userName").val(),
                password:$("#userPassword").val(),
                sex:$("input[name='sex']:checked").val(),
                birthYear:valOfYear,
                phoneNumber:$("#phoneNumber").val(),
                img:$("#imgid").attr("src")
            }
        $.ajax({
            url : '${pageContext.request.contextPath}/register/register/register',
            type:'post',
            data:info,
            success : function(data) {
                alert("success");
            },
            error : function(error) {
                alert("failed");
            }
        });
    }

</script>
</html>
