<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>부서별 직원 조회</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
            border: none;
            border-radius: 0.5rem;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/index.do">
                <i class="bi bi-people-fill"></i> EMP Management
            </a>
            <div class="ms-auto">
                <a href="${pageContext.request.contextPath}/emp/emp.do" class="btn btn-outline-light">
                    <i class="bi bi-arrow-left"></i> 전체 목록
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-0">
                    <i class="bi bi-building"></i> 부서별 직원 목록
                </h2>
                <p class="text-muted mb-0">
                    <c:choose>
                        <c:when test="${deptno == 10}">ACCOUNTING 부서</c:when>
                        <c:when test="${deptno == 20}">RESEARCH 부서</c:when>
                        <c:when test="${deptno == 30}">SALES 부서</c:when>
                        <c:when test="${deptno == 40}">OPERATIONS 부서</c:when>
                        <c:otherwise>부서 ${deptno}</c:otherwise>
                    </c:choose>
                    의 직원 목록입니다.
                </p>
            </div>
            <div>
                <span class="badge bg-secondary" style="font-size: 1.5rem; padding: 0.75rem 1.5rem;">
                    DEPT ${deptno}
                </span>
            </div>
        </div>

        <!-- Department Filter -->
        <div class="mb-3">
            <div class="btn-group" role="group">
                <a href="${pageContext.request.contextPath}/emp/empByDept.do?deptno=10" 
                   class="btn ${deptno == 10 ? 'btn-primary' : 'btn-outline-primary'}">
                    부서 10
                </a>
                <a href="${pageContext.request.contextPath}/emp/empByDept.do?deptno=20" 
                   class="btn ${deptno == 20 ? 'btn-primary' : 'btn-outline-primary'}">
                    부서 20
                </a>
                <a href="${pageContext.request.contextPath}/emp/empByDept.do?deptno=30" 
                   class="btn ${deptno == 30 ? 'btn-primary' : 'btn-outline-primary'}">
                    부서 30
                </a>
                <a href="${pageContext.request.contextPath}/emp/empByDept.do?deptno=40" 
                   class="btn ${deptno == 40 ? 'btn-primary' : 'btn-outline-primary'}">
                    부서 40
                </a>
            </div>
        </div>

        <!-- Employee List -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th width="12%">사원번호</th>
                                <th width="15%">이름</th>
                                <th width="15%">직책</th>
                                <th width="12%">매니저</th>
                                <th width="15%">입사일</th>
                                <th width="13%">급여</th>
                                <th width="10%">커미션</th>
                                <th width="8%">상세</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty list}">
                                    <tr>
                                        <td colspan="8" class="text-center py-5">
                                            <i class="bi bi-inbox" style="font-size: 3rem; color: #dee2e6;"></i>
                                            <p class="text-muted mt-3">해당 부서에 직원이 없습니다.</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="emp" items="${list}">
                                        <tr>
                                            <td><strong>${emp.empno}</strong></td>
                                            <td>
                                                <i class="bi bi-person-circle text-primary"></i> ${emp.ename}
                                            </td>
                                            <td>
                                                <span class="badge bg-info">${emp.job}</span>
                                            </td>
                                            <td>${emp.mgr != null ? emp.mgr : '-'}</td>
                                            <td>
                                                <fmt:formatDate value="${emp.hiredate}" pattern="yyyy-MM-dd"/>
                                            </td>
                                            <td>
                                                <strong class="text-success">
                                                    $<fmt:formatNumber value="${emp.sal}" pattern="#,##0"/>
                                                </strong>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${emp.comm != null && emp.comm > 0}">
                                                        $<fmt:formatNumber value="${emp.comm}" pattern="#,##0"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/emp/empDetail.do?empno=${emp.empno}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Summary Card -->
        <c:if test="${not empty list}">
            <div class="row mt-4">
                <div class="col-md-6">
                    <div class="card bg-light">
                        <div class="card-body text-center">
                            <h5 class="card-title">총 직원 수</h5>
                            <p class="display-4">${list.size()}</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card bg-light">
                        <div class="card-body text-center">
                            <h5 class="card-title">평균 급여</h5>
                            <p class="display-4 text-success">
                                <c:set var="totalSal" value="0"/>
                                <c:forEach var="emp" items="${list}">
                                    <c:set var="totalSal" value="${totalSal + emp.sal}"/>
                                </c:forEach>
                                $<fmt:formatNumber value="${totalSal / list.size()}" pattern="#,##0"/>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
