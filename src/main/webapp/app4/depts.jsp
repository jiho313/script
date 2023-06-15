<%@page import="com.google.gson.Gson"%>
<%@page import="vo.Dept"%>
<%@page import="java.util.List"%>
<%@page import="dao.HrDao"%>
<%@ page contentType="application/json; charset=utf-8" pageEncoding="utf-8" trimDirectiveWhitespaces="true" %>
<%
	// 1. 요청 파라미터값 조회하기
	int locationId = Integer.parseInt(request.getParameter("id"));
	System.out.println("소재지아이디 -> " + locationId);
	
	// 2. 부서목록 조회하기
	HrDao hrDao = new HrDao();
	List<Dept> depts = hrDao.getDeptsByLocId(locationId);
	
	// 3. 부서목록 정보를 json 형식의 텍스트로 변환한다.
	Gson gson = new Gson();
	String text = gson.toJson(depts);
	
	// 4. 응답으로 json 텍스트를 보낸다.
	out.write(text);
	/* name:value 스크립트 객체 표기법으로 출력 여기서 name은 객체의 필드명, value는 필드의 값
	   json은 두가지 형식 배열 형식과 객체 형식. [{}], {} */
	/* 자바의 리스트 객체는 [객체, 객체]
							[{name:value, name:value}]
									
	   자바의 객체, 맵		{name:value, name:value}
	*/
%>