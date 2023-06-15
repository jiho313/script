<%@page import="vo.Location"%>
<%@page import="java.util.List"%>
<%@page import="dao.HrDao"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
	HrDao dao = new HrDao();
	
	// 모든 도시 정보를 조회한다.
	List<Location> locList = dao.getLocations();
%>
<!doctype html>
<html lang="ko">
<head>
<title>ajax 실습</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
</head>
<body>
<div class="container">
	<h1>ajax 실습</h1>
	<!-- 커피를 산다면 내가 주문해놓고 다른 사람이 주문할 수 있는 방식이 비동기 데이터 전송방식 여기서 진동벨의 역할을 하는 객체
								-> readyState이다. 이 진동벨을 4번 울리는데 울릴때마다(값이 바뀔 때마다) onreadystatechange라는 이벤트 발생
								-> 요청이 완료되었다면 readyState의 값은 4다.
		               내가 주문해서 받을 때까지 다른 사람이 주문할 수 없다면 동기식 데이터 전송방식 -->
	<h3>부서 조회</h3>
	<div>
		<label>도시명</label>
		<select id="city" onchange="refreshDepts();">
			<option value="" selected disabled>-- 선택하세요 -- </option> 
		
<%
	for (Location location : locList) {
%>
			<option value="<%=location.getId() %>"><%=location.getCity() %></option>
<%
	}
%>		
		</select>
	</div>
	
	<div>
		<label>부서명</label>
		<select id="dept" onchange="refreshEmps();">
			<option>-- 선택하세요 -- </option> 
		</select>
	</div>

	<div>
		<h3>직원 리스트</h3>
		<table class="table" id="table-employees">
			<thead>
				<tr>
					<th>아이디</th>
					<th>이름</th>
					<th>이메일</th>
					<th>전화번호</th>
					<th>직종아이디</th>
					<th>급여</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
	function refreshEmps() {
		// select 박스에서 선택된 값 조회하기
		let deptId = document.getElementById("dept").value;
		
		// ajax 통신
		let xhr = new XMLHttpRequest();
		xhr.onreadystatechange = function() {
			if (xhr.readyState == 4) {
				let text = xhr.responseText;
				let arr = JSON.parse(text);
				
				let htmlContents = "";
				arr.forEach(function(item, index) {
					htmlContents += `
						<tr>
							<td>\${item.id}</td>
							<td>\${item.firstName} \${item.lastName}</td>
							<td>\${item.email}</td>
							<td>\${item.phoneNumber}</td>
							<td>\${item.jobId}</td>
							<td>\${item.salary}</td>
						</tr>
					`;
				})
				
				document.querySelector("#table-employees tbody").innerHTML = htmlContents;
				// innerHtml - 선택된 아이디(table-employees )의 태그(tbody
						) 안에 넣는다.
			}
		};
		xhr.open("GET", "emps.jsp?id=" + deptId);
		xhr.send(false); // post타입일 때 데이터가 들어갈 자리 제이쿼리로 쉽게 할 수 있??
	}

	function refreshDepts() {
		// select 박스의 현재 선택된 값을 조회한다.
		let locId = document.getElementById("city").value;
		
		// ajax 통신하기
		// 1. XMLHttpRequest 객체 생성하기
		let xhr = new XMLHttpRequest();
		
		// 2. XmlHttpRequest 객체에서 onreadystatechnge 이벤트가 발생할 때마다 실행할 함수 지정
		xhr.onreadystatechange = function() {
			//console.log("readyState", xhr.readyState);
			if (xhr.readyState == 4) {
				// 1. 응답데이터 조회하기
				let data = xhr.responseText; // date -> '[{id:100, name:"기술부"}, {id:101, name:"영업부"}]' 순수 텍스트
	
				// 2. 응답데이터를(텍스트)를 객체(자바스크립트 객체 혹은 배열(자바에선 리스트)객체)로 변환하기
				let arr = JSON.parse(data); // arr -> [{id:100, name:"기술부"}, {id:101, name:"영업부"}] 텍스트가 변환된 배열
				
				// 3. 응답데이터로 html컨텐츠 생성하기
				let htmlContent = "<option selected disabled>-- 선택하세요 -- </option>";
				arr.forEach(function(item, index) {
					// item -> {id:100, name:"기술부"} 배열에 담긴 각각의 객체
					let deptId = item.id;
					let deptName = item.name;
					
					htmlContent += `<option value="\${deptId}">\${deptName}</option>`;
				});
				// 4. 화면에 html 컨텐츠 반영시키기
				document.getElementById("dept").innerHTML = htmlContent;
				// innerHtml - 선택된 아이디(dept)태그 안에 htmlContent를 넣는다.
			}
		}
		
		// 3. XmlHttpRequest 객체 초기화하기 (요청방식, 요청URL 지정)
		xhr.open("GET", "depts.jsp?id=" + locId);
		// 4. 서버로 요청 보내기
		xhr.send(null);
	}
</script>
</body>
</html>