<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>부서 관리 시스템</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 2rem 0;
        }
        .main-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 2rem;
        }
        .header-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
        }
        .search-box {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
        }
        .table-container {
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }
        .table thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .table tbody tr {
            transition: all 0.3s ease;
        }
        .table tbody tr:hover {
            background-color: #f8f9fa;
            transform: scale(1.01);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .btn-custom {
            border-radius: 25px;
            padding: 0.5rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .badge-custom {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
        }
        .action-buttons .btn {
            margin: 0 0.2rem;
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="main-container">
            <!-- Header Section -->
            <div class="header-section text-center">
                <h1 class="mb-2"><i class="bi bi-building"></i> 부서 관리 시스템</h1>
                <p class="mb-0">Department Management System</p>
            </div>

            <!-- Search and Add Section -->
            <div class="search-box">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-white">
                                <i class="bi bi-search"></i>
                            </span>
                            <input type="number" class="form-control" id="deptnoSearch" 
                                   placeholder="부서번호로 검색...">
                            <button class="btn btn-primary btn-custom" id="searchBtn">
                                <i class="bi bi-search"></i> 검색
                            </button>
                            <button class="btn btn-secondary btn-custom" id="resetBtn">
                                <i class="bi bi-arrow-clockwise"></i> 전체보기
                            </button>
                        </div>
                    </div>
                    <div class="col-md-4 text-end mt-3 mt-md-0">
                        <button class="btn btn-success btn-custom" id="addDeptBtn">
                            <i class="bi bi-plus-circle"></i> 부서 등록
                        </button>
                    </div>
                </div>
            </div>

            <!-- Table Section -->
            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th width="15%">부서번호</th>
                                <th width="30%">부서명</th>
                                <th width="30%">위치</th>
                                <th width="25%" class="text-center">관리</th>
                            </tr>
                        </thead>
                        <tbody id="deptList">
                            <tr class="empty-state">
                                <td colspan="4">
                                    <div>
                                        <i class="bi bi-inbox"></i>
                                        <p>데이터를 불러오는 중...</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Statistics -->
            <div class="mt-3 text-muted text-center">
                <small>총 <span id="totalCount" class="fw-bold text-primary">0</span>개의 부서</small>
            </div>
        </div>
    </div>

    <!-- Add/Edit Modal -->
    <div class="modal fade" id="deptModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">
                        <i class="bi bi-plus-circle"></i> 부서 등록
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="deptForm">
                        <div class="mb-3">
                            <label for="deptno" class="form-label">
                                <i class="bi bi-hash"></i> 부서번호
                            </label>
                            <input type="number" class="form-control" id="deptno" required>
                        </div>
                        <div class="mb-3">
                            <label for="dname" class="form-label">
                                <i class="bi bi-building"></i> 부서명
                            </label>
                            <input type="text" class="form-control" id="dname" required>
                        </div>
                        <div class="mb-3">
                            <label for="loc" class="form-label">
                                <i class="bi bi-geo-alt"></i> 위치
                            </label>
                            <input type="text" class="form-control" id="loc" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-custom" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle"></i> 취소
                    </button>
                    <button type="button" class="btn btn-primary btn-custom" id="saveBtn">
                        <i class="bi bi-check-circle"></i> 저장
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Detail Modal -->
    <div class="modal fade" id="detailModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-info-circle"></i> 부서 상세정보
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="card border-0">
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-4 text-muted">
                                    <i class="bi bi-hash"></i> 부서번호
                                </div>
                                <div class="col-8 fw-bold" id="detailDeptno"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-4 text-muted">
                                    <i class="bi bi-building"></i> 부서명
                                </div>
                                <div class="col-8 fw-bold" id="detailDname"></div>
                            </div>
                            <div class="row">
                                <div class="col-4 text-muted">
                                    <i class="bi bi-geo-alt"></i> 위치
                                </div>
                                <div class="col-8 fw-bold" id="detailLoc"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-custom" id="editFromDetailBtn">
                        <i class="bi bi-pencil"></i> 수정
                    </button>
                    <button type="button" class="btn btn-danger btn-custom" id="deleteFromDetailBtn">
                        <i class="bi bi-trash"></i> 삭제
                    </button>
                    <button type="button" class="btn btn-secondary btn-custom" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle"></i> 닫기
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        let isEditMode = false;
        let currentDeptno = null;
        const contextPath = '${pageContext.request.contextPath}';

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            loadDeptList();
            
            // Event Listeners
            document.getElementById('searchBtn').addEventListener('click', searchDept);
            document.getElementById('resetBtn').addEventListener('click', loadDeptList);
            document.getElementById('addDeptBtn').addEventListener('click', showAddModal);
            document.getElementById('saveBtn').addEventListener('click', saveDept);
            document.getElementById('editFromDetailBtn').addEventListener('click', editFromDetail);
            document.getElementById('deleteFromDetailBtn').addEventListener('click', deleteFromDetail);
            
            // Enter key search
            document.getElementById('deptnoSearch').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchDept();
                }
            });
        });

        // Load department list
        function loadDeptList() {
            console.log('전체 조회 시작, URL:', contextPath + '/dept');
            fetch(contextPath + '/dept')
                .then(response => {
                    console.log('응답 상태:', response.status);
                    if (!response.ok) throw new Error('Network response was not ok');
                    return response.json();
                })
                .then(data => {
                    console.log('받은 JSON 데이터:', data);
                    displayDeptList(data);
                    document.getElementById('totalCount').textContent = data.length;
                })
                .catch(error => {
                    console.error('Error:', error);
                    showError('데이터를 불러오는데 실패했습니다.');
                });
        }

        // Display department list
        function displayDeptList(deptList) {
            console.log('받은 데이터:', deptList);
            const tbody = document.getElementById('deptList');
            
            if (deptList.length === 0) {
                tbody.innerHTML = `
                    <tr class="empty-state">
                        <td colspan="4">
                            <div>
                                <i class="bi bi-inbox"></i>
                                <p>등록된 부서가 없습니다.</p>
                            </div>
                        </td>
                    </tr>
                `;
                return;
            }

            tbody.innerHTML = deptList.map(dept => 
                '<tr>' +
                    '<td><span class="badge badge-custom bg-primary">' + dept.deptno + '</span></td>' +
                    '<td><strong>' + dept.dname + '</strong></td>' +
                    '<td><i class="bi bi-geo-alt-fill text-danger"></i> ' + dept.loc + '</td>' +
                    '<td class="text-center action-buttons">' +
                        '<button class="btn btn-sm btn-info text-white" onclick="showDetail(' + dept.deptno + ')">' +
                            '<i class="bi bi-eye"></i> 상세' +
                        '</button>' +
                        '<button class="btn btn-sm btn-warning text-white" onclick="showEditModal(' + dept.deptno + ', \'' + dept.dname + '\', \'' + dept.loc + '\')">' +
                            '<i class="bi bi-pencil"></i> 수정' +
                        '</button>' +
                        '<button class="btn btn-sm btn-danger" onclick="deleteDept(' + dept.deptno + ')">' +
                            '<i class="bi bi-trash"></i> 삭제' +
                        '</button>' +
                    '</td>' +
                '</tr>'
            ).join('');
        }

        // Search department
        function searchDept() {
            const deptno = document.getElementById('deptnoSearch').value;
            
            if (!deptno) {
                loadDeptList();
                return;
            }

            fetch(contextPath + '/dept/' + deptno)
                .then(response => {
                    if (!response.ok) throw new Error('부서를 찾을 수 없습니다.');
                    return response.json();
                })
                .then(dept => {
                    displayDeptList([dept]);
                    document.getElementById('totalCount').textContent = 1;
                })
                .catch(error => {
                    console.error('Error:', error);
                    showError('해당 부서를 찾을 수 없습니다.');
                    displayDeptList([]);
                });
        }

        // Show add modal
        function showAddModal() {
            isEditMode = false;
            document.getElementById('modalTitle').innerHTML = '<i class="bi bi-plus-circle"></i> 부서 등록';
            document.getElementById('deptForm').reset();
            document.getElementById('deptno').removeAttribute('readonly');
            new bootstrap.Modal(document.getElementById('deptModal')).show();
        }

        // Show edit modal
        function showEditModal(deptno, dname, loc) {
            isEditMode = true;
            currentDeptno = deptno;
            document.getElementById('modalTitle').innerHTML = '<i class="bi bi-pencil"></i> 부서 수정';
            document.getElementById('deptno').value = deptno;
            document.getElementById('dname').value = dname;
            document.getElementById('loc').value = loc;
            document.getElementById('deptno').setAttribute('readonly', 'readonly');
            new bootstrap.Modal(document.getElementById('deptModal')).show();
        }

        // Show detail modal
        function showDetail(deptno) {
            console.log('상세보기 요청:', deptno);
            fetch(contextPath + '/dept/' + deptno)
                .then(response => {
                    console.log('상세 응답:', response);
                    return response.json();
                })
                .then(dept => {
                    console.log('상세 데이터:', dept);
                    currentDeptno = deptno;
                    document.getElementById('detailDeptno').textContent = dept.deptno;
                    document.getElementById('detailDname').textContent = dept.dname;
                    document.getElementById('detailLoc').textContent = dept.loc;
                    new bootstrap.Modal(document.getElementById('detailModal')).show();
                })
                .catch(error => {
                    console.error('Error:', error);
                    showError('상세 정보를 불러오는데 실패했습니다.');
                });
        }

        // Edit from detail modal
        function editFromDetail() {
            const deptno = document.getElementById('detailDeptno').textContent;
            const dname = document.getElementById('detailDname').textContent;
            const loc = document.getElementById('detailLoc').textContent;
            
            bootstrap.Modal.getInstance(document.getElementById('detailModal')).hide();
            showEditModal(deptno, dname, loc);
        }

        // Delete from detail modal
        function deleteFromDetail() {
            const deptno = document.getElementById('detailDeptno').textContent;
            bootstrap.Modal.getInstance(document.getElementById('detailModal')).hide();
            deleteDept(deptno);
        }

        // Save department
        function saveDept() {
            const deptno = document.getElementById('deptno').value;
            const dname = document.getElementById('dname').value;
            const loc = document.getElementById('loc').value;

            if (!deptno || !dname || !loc) {
                showError('모든 필드를 입력해주세요.');
                return;
            }

            const dept = {
                deptno: parseInt(deptno),
                dname: dname,
                loc: loc
            };

            const url = contextPath + '/dept';
            const method = isEditMode ? 'PUT' : 'POST';

            fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(dept)
            })
            .then(response => {
                if (!response.ok) throw new Error('저장에 실패했습니다.');
                return response.text();
            })
            .then(data => {
                bootstrap.Modal.getInstance(document.getElementById('deptModal')).hide();
                showSuccess(isEditMode ? '수정되었습니다.' : '등록되었습니다.');
                loadDeptList();
            })
            .catch(error => {
                console.error('Error:', error);
                showError(isEditMode ? '수정에 실패했습니다.' : '등록에 실패했습니다.');
            });
        }

        // Delete department
        function deleteDept(deptno) {
            if (!confirm('정말 삭제하시겠습니까?')) {
                return;
            }

            fetch(contextPath + '/dept/' + deptno, {
                method: 'DELETE'
            })
            .then(response => {
                if (!response.ok) throw new Error('삭제에 실패했습니다.');
                return response.text();
            })
            .then(data => {
                showSuccess('삭제되었습니다.');
                loadDeptList();
            })
            .catch(error => {
                console.error('Error:', error);
                showError('삭제에 실패했습니다. (web.xml에 HiddenHttpMethodFilter 필요)');
            });
        }

        // Show success message
        function showSuccess(message) {
            alert(message);
        }

        // Show error message
        function showError(message) {
            alert(message);
        }
    </script>
</body>
</html>
