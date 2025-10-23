<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>직원 관리 시스템</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        .card {
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
            border: none;
            border-radius: 0.5rem;
        }
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
            cursor: pointer;
        }
        .badge-custom {
            padding: 0.5em 0.75em;
            font-size: 0.875rem;
        }
        .search-form {
            background-color: white;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
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
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/emp/emp.do">
                            <i class="bi bi-person-lines-fill"></i> 직원관리
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/customer/notice.do">
                            <i class="bi bi-bell"></i> 공지사항
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/index.do">
                            <i class="bi bi-house"></i> HOME
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-0"><i class="bi bi-person-badge"></i> 직원 목록</h2>
                <p class="text-muted mb-0">전체 직원 정보를 조회하고 관리합니다</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/emp/empReg.do" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> 직원 등록
                </a>
            </div>
        </div>

        <!-- Search Form -->
        <div class="search-form">
            <form action="${pageContext.request.contextPath}/emp/emp.do" method="get">
                <div class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label for="f" class="form-label">검색 필드</label>
                        <select name="f" id="f" class="form-select">
                            <option value="">전체</option>
                            <option value="ename" ${param.f == 'ename' ? 'selected' : ''}>이름</option>
                            <option value="job" ${param.f == 'job' ? 'selected' : ''}>직책</option>
                            <option value="deptno" ${param.f == 'deptno' ? 'selected' : ''}>부서번호</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="q" class="form-label">검색어</label>
                        <input type="text" name="q" id="q" class="form-control" 
                               placeholder="검색어를 입력하세요" value="${param.q}">
                    </div>
                    <div class="col-md-3">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Quick Filters -->
        <div class="mb-3">
            <div class="btn-group" role="group">
                <a href="${pageContext.request.contextPath}/emp/emp.do" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-list"></i> 전체
                </a>
                <a href="${pageContext.request.contextPath}/emp/empByDept.do?deptno=10" class="btn btn-outline-secondary btn-sm">
                    부서 10
                </a>
                <a href="${pageContext.request.contextPath}/emp/empByDept.do?deptno=20" class="btn btn-outline-secondary btn-sm">
                    부서 20
                </a>
                <a href="${pageContext.request.contextPath}/emp/empByDept.do?deptno=30" class="btn btn-outline-secondary btn-sm">
                    부서 30
                </a>
                <a href="${pageContext.request.contextPath}/emp/empByJob.do?job=MANAGER" class="btn btn-outline-secondary btn-sm">
                    매니저
                </a>
                <a href="${pageContext.request.contextPath}/emp/empByJob.do?job=SALESMAN" class="btn btn-outline-secondary btn-sm">
                    영업사원
                </a>
            </div>
        </div>

        <!-- Employee List Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th width="10%">사원번호</th>
                                <th width="15%">이름</th>
                                <th width="15%">직책</th>
                                <th width="10%">매니저</th>
                                <th width="15%">입사일</th>
                                <th width="12%">급여</th>
                                <th width="10%">커미션</th>
                                <th width="10%">부서</th>
                                <th width="13%">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty list}">
                                    <tr>
                                        <td colspan="9" class="text-center py-5">
                                            <i class="bi bi-inbox" style="font-size: 3rem; color: #dee2e6;"></i>
                                            <p class="text-muted mt-3">등록된 직원이 없습니다.</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="emp" items="${list}">
                                        <tr onclick="location.href='${pageContext.request.contextPath}/emp/empDetail.do?empno=${emp.empno}'" style="cursor: pointer;">
                                            <td><strong>${emp.empno}</strong></td>
                                            <td>
                                                <i class="bi bi-person-circle text-primary"></i> ${emp.ename}
                                            </td>
                                            <td>
                                                <span class="badge bg-info badge-custom">${emp.job}</span>
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
                                                <span class="badge bg-secondary badge-custom">DEPT ${emp.deptno}</span>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm" role="group" onclick="event.stopPropagation();">
                                                    <a href="${pageContext.request.contextPath}/emp/empDetail.do?empno=${emp.empno}" 
                                                       class="btn btn-outline-primary" title="상세보기">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/emp/empEdit.do?empno=${emp.empno}" 
                                                       class="btn btn-outline-success" title="수정">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/emp/empDel.do?empno=${emp.empno}" 
                                                       class="btn btn-outline-danger" title="삭제"
                                                       onclick="return confirm('정말 삭제하시겠습니까?');">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </div>
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

        <!-- Pagination (Optional) -->
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item disabled">
                    <a class="page-link" href="#" tabindex="-1">이전</a>
                </li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#">3</a></li>
                <li class="page-item">
                    <a class="page-link" href="#">다음</a>
                </li>
            </ul>
        </nav>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
