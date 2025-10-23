<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>직원 상세 정보</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .info-card {
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
        }
        .info-row {
            padding: 1rem;
            border-bottom: 1px solid #e9ecef;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            width: 150px;
        }
        .info-value {
            color: #212529;
        }
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 0.5rem 0.5rem 0 0;
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
                    <i class="bi bi-arrow-left"></i> 목록으로
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Profile Header -->
                <div class="profile-header text-center">
                    <i class="bi bi-person-circle" style="font-size: 5rem;"></i>
                    <h2 class="mt-3 mb-1">${emp.ename}</h2>
                    <p class="mb-0">사원번호: ${emp.empno}</p>
                </div>

                <!-- Employee Info Card -->
                <div class="info-card">
                    <div class="info-row d-flex">
                        <div class="info-label">
                            <i class="bi bi-briefcase text-primary"></i> 직책
                        </div>
                        <div class="info-value flex-grow-1">
                            <span class="badge bg-info" style="font-size: 1rem; padding: 0.5rem 1rem;">
                                ${emp.job}
                            </span>
                        </div>
                    </div>

                    <div class="info-row d-flex">
                        <div class="info-label">
                            <i class="bi bi-person-check text-primary"></i> 매니저
                        </div>
                        <div class="info-value flex-grow-1">
                            ${emp.mgr != null ? emp.mgr : '없음'}
                        </div>
                    </div>

                    <div class="info-row d-flex">
                        <div class="info-label">
                            <i class="bi bi-calendar-event text-primary"></i> 입사일
                        </div>
                        <div class="info-value flex-grow-1">
                            <fmt:formatDate value="${emp.hiredate}" pattern="yyyy년 MM월 dd일"/>
                        </div>
                    </div>

                    <div class="info-row d-flex">
                        <div class="info-label">
                            <i class="bi bi-cash-coin text-primary"></i> 급여
                        </div>
                        <div class="info-value flex-grow-1">
                            <strong class="text-success" style="font-size: 1.25rem;">
                                $<fmt:formatNumber value="${emp.sal}" pattern="#,##0"/>
                            </strong>
                        </div>
                    </div>

                    <div class="info-row d-flex">
                        <div class="info-label">
                            <i class="bi bi-gift text-primary"></i> 커미션
                        </div>
                        <div class="info-value flex-grow-1">
                            <c:choose>
                                <c:when test="${emp.comm != null && emp.comm > 0}">
                                    <strong class="text-warning">
                                        $<fmt:formatNumber value="${emp.comm}" pattern="#,##0"/>
                                    </strong>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">없음</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="info-row d-flex">
                        <div class="info-label">
                            <i class="bi bi-building text-primary"></i> 부서번호
                        </div>
                        <div class="info-value flex-grow-1">
                            <span class="badge bg-secondary" style="font-size: 1rem; padding: 0.5rem 1rem;">
                                DEPT ${emp.deptno}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex gap-2 mt-4 justify-content-center">
                    <a href="${pageContext.request.contextPath}/emp/emp.do" class="btn btn-secondary">
                        <i class="bi bi-list"></i> 목록
                    </a>
                    <a href="${pageContext.request.contextPath}/emp/empEdit.do?empno=${emp.empno}" 
                       class="btn btn-success">
                        <i class="bi bi-pencil-square"></i> 수정
                    </a>
                    <a href="${pageContext.request.contextPath}/emp/empDel.do?empno=${emp.empno}" 
                       class="btn btn-danger"
                       onclick="return confirm('정말 삭제하시겠습니까?');">
                        <i class="bi bi-trash"></i> 삭제
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
