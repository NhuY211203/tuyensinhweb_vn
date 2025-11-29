const API_BASE_URL = 'http://localhost:8000/api';

class ApiService {
  constructor() {
    this.baseURL = API_BASE_URL;
  }

  async request(endpoint, options = {}) {
    const url = `${this.baseURL}${endpoint}`;
    
    // Get token from localStorage
    const token = localStorage.getItem('token');
    
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...(token && { 'Authorization': `Bearer ${token}` }),
        ...options.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Có lỗi xảy ra');
      }

      return data;
    } catch (error) {
      console.error('API Error:', error);
      throw error;
    }
  }

  // GET request
  async get(endpoint, params = {}) {
    const queryString = new URLSearchParams(params).toString();
    const url = queryString ? `${endpoint}?${queryString}` : endpoint;
    return this.request(url, { method: 'GET' });
  }

  // POST request
  async post(endpoint, data = {}) {
    return this.request(endpoint, {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }

  // PUT request
  async put(endpoint, data = {}) {
    return this.request(endpoint, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  }

  // DELETE request
  async delete(endpoint) {
    return this.request(endpoint, { method: 'DELETE' });
  }

  // Consultant APIs
  async getConsultants(params = {}) {
    return this.get('/staff/consultants', params);
  }

  async getConsultantById(id) {
    return this.get(`/staff/consultants/${id}`);
  }

  async createConsultant(data) {
    return this.post('/staff/consultants', data);
  }

  async updateConsultant(id, data) {
    return this.put(`/staff/consultants/${id}`, data);
  }

  async deleteConsultant(id) {
    return this.delete(`/staff/consultants/${id}`);
  }

  async updateConsultantStatus(id, status) {
    return this.put(`/staff/consultants/${id}/status`, { status });
  }

  // Major Groups APIs
  async getMajorGroups() {
    // Use endpoint that includes consultant counts per group
    return this.get('/major-groups');
  }

  // Consultants by major group
  async getConsultantsByMajorGroup(groupId) {
    // Backend expects query param idnhomnganh
    return this.get('/consultants', { idnhomnganh: groupId });
  }

  // Available slots for a consultant - allow filtering by duyetlich (approval)
  async getAvailableSlots(consultantId, params = {}) {
    const query = {
      consultant_id: consultantId,
      duyetlich: 2, // only approved schedules
      status: 1,    // only available slots (server expects 'status')
      date_filter: 'future', // only future schedules
      ...params,
    };
    return this.get('/consultation-schedules', query);
  }

  // Consultants grouped by major
  async getConsultantsGroupedByMajor() {
    return this.get('/consultants-grouped');
  }

  // Consultation schedules for approval
  async getConsultationSchedulesForApproval(params = {}) {
    return this.get('/consultation-schedules-for-approval', params);
  }

  async approveConsultationSchedule(scheduleIds, action, note = '') {
    console.log('API service: approveConsultationSchedule called with:', { scheduleIds, action, note });
    try {
      // Get current user ID from localStorage
      const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
      const approverId = currentUser.idnguoidung || currentUser.id || 34; // Fallback to 34
      console.log('API service: current user:', currentUser);
      console.log('API service: approver ID:', approverId);
      
      // If no user found, try to get from sessionStorage or use default
      if (!approverId || approverId === 34) {
        console.log('API service: No valid user ID found, using default');
      }
      
      const requestData = {
        scheduleIds,
        action,
        note,
        approverId
      };
      console.log('API service: sending request data:', requestData);
      const result = await this.post('/consultation-schedules/approve', requestData);
      console.log('API service: response received:', result);
      return result;
    } catch (error) {
      console.error('API service: error occurred:', error);
      throw error;
    }
  }

  // Booking/Payment: create a booking for a consultation schedule
  // Payload shape is determined by caller; this function forwards to backend
  async bookConsultationSchedule(bookingData = {}) {
    // Backend route: POST /consultation-schedules/{id}/book
    const scheduleId = bookingData.scheduleId ?? bookingData.idlichtuvan;
    const payload = {
      user_id: bookingData.userId ?? bookingData.idnguoidat,
      // Backend chỉ cần user_id, các field khác sẽ được set tự động
    };
    return this.post(`/consultation-schedules/${scheduleId}/book`, payload);
  }

  // Get current user's booked appointments (status = 2)
  async getMyAppointments(params = {}) {
    const user = JSON.parse(localStorage.getItem('user') || '{}');
    const userId = user.idnguoidung || user.id;
    const query = { user_id: userId, ...params };
    return this.get('/my-appointments', query);
  }

  // Ratings APIs for danhgia_lichtuvan
  async getScheduleRating(scheduleId) {
    return this.get('/ratings/by-schedule', { lichtuvan_id: scheduleId });
  }

  async getConsultantRating(consultantId) {
    return this.get('/ratings/by-consultant', { consultant_id: consultantId });
  }

  // Consultation notes APIs
  async getConsultationNoteBySession(sessionId) {
    return this.get(`/consultation-notes/${sessionId}`);
  }

  async createScheduleRating(data) {
    // data: { idlichtuvan, idnguoidat, diemdanhgia, nhanxet, an_danh }
    return this.post('/ratings', data);
  }

  async updateScheduleRating(id, data) {
    return this.put(`/ratings/${id}`, data);
  }

  // Chat APIs
  async getChatContacts(consultantId) {
    return this.get('/chat/contacts', { consultant_id: consultantId });
  }

  async getOrCreateChatRoom(consultantId, userId, scheduleId) {
    const params = { consultant_id: consultantId, user_id: userId };
    if (scheduleId) params.schedule_id = scheduleId;
    return this.get('/chat/room', params);
  }

  async getChatMessagesByRoom(roomId, params = {}) {
    return this.get('/chat/messages', { room_id: roomId, ...params });
  }

  async sendChatMessageByRoom({ roomId, senderId, content }) {
    return this.post('/chat/messages', { room_id: roomId, sender_id: senderId, content });
  }

  // Notification APIs
  async sendNotification(notificationData) {
    return this.post('/notifications/send', notificationData);
  }

  async scheduleNotification(notificationData) {
    return this.post('/notifications/schedule', notificationData);
  }

  async getNotifications(params = {}) {
    return this.get('/notifications', params);
  }

  async getNotificationById(id) {
    return this.get(`/notifications/${id}`);
  }

  async updateNotificationStatus(id, status) {
    return this.put(`/notifications/${id}/status`, { status });
  }

  async getNotificationRecipients(notificationId, params = {}) {
    return this.get(`/notifications/${notificationId}/recipients`, params);
  }

  async getNotificationDetail(id) {
    return this.get(`/notifications/${id}`);
  }

  async openScheduleRegistration() {
    // Get user ID from localStorage
    const user = JSON.parse(localStorage.getItem('user') || '{}');
    const userId = user.idnguoidung || user.id;
    
    console.log('openScheduleRegistration - user from localStorage:', user);
    console.log('openScheduleRegistration - userId:', userId);
    
    const body = {};
    if (userId) {
      body.user_id = userId;
    }
    
    console.log('openScheduleRegistration - request body:', body);
    
    return this.post('/notifications/open-schedule-registration', body);
  }

  async checkScheduleRegistrationStatus() {
    return this.get('/notifications/check-schedule-registration-status');
  }

  async getNotificationStats(params = {}) {
    return this.get('/notifications/stats', params);
  }

  // Get notifications for current user (consultants)
  async getMyNotifications(params = {}) {
    // Get user ID from localStorage
    const user = JSON.parse(localStorage.getItem('user') || '{}');
    const userId = user.idnguoidung || user.id;
    
    if (userId) {
      params.user_id = userId;
    }
    
    return this.get('/notifications/my', params);
  }

  // Mark notification as read
  async markNotificationAsRead(id) {
    // Get user ID from localStorage
    const user = JSON.parse(localStorage.getItem('user') || '{}');
    const userId = user.idnguoidung || user.id;
    
    return this.put(`/notifications/${id}/read`, { user_id: userId });
  }

  // Authentication APIs
  async login(email, password) {
    return this.post('/login', { email, matkhau: password });
  }

  async register(userData) {
    return this.post('/register', userData);
  }

  async getCareerTestQuestions() {
    return this.get('/career-test/questions');
  }

  async submitCareerTest(answers) {
    return this.post('/career-test/submit', { answers });
  }

  // Tin Tuyen Sinh (News) APIs
  async getNewsList(params = {}) {
    return this.get('/admin/tin-tuyen-sinh', params);
  }

  async getNewsById(id) {
    return this.get(`/admin/tin-tuyen-sinh/${id}`);
  }

  async createNews(data) {
    return this.post('/admin/tin-tuyen-sinh', data);
  }

  async updateNews(id, data) {
    return this.put(`/admin/tin-tuyen-sinh/${id}`, data);
  }

  async deleteNews(id) {
    return this.delete(`/admin/tin-tuyen-sinh/${id}`);
  }

  async approveNews(id, postData) {
    // Update status to "Đã duyệt"
    return this.updateNews(id, { ...postData, trang_thai: "Đã duyệt" });
  }

  async rejectNews(id, postData) {
    // Update status to "Đã gỡ"
    return this.updateNews(id, { ...postData, trang_thai: "Đã gỡ" });
  }

  async hideNews(id, postData) {
    // Update status to "Ẩn"
    return this.updateNews(id, { ...postData, trang_thai: "Ẩn" });
  }

  // Public news APIs (only approved news)
  async getPublicNewsList(params = {}) {
    return this.get('/tin-tuyen-sinh', params);
  }

  async getPublicNewsById(id) {
    return this.get(`/tin-tuyen-sinh/${id}`);
  }

  // User management APIs
  async createUser(userData) {
    return this.post('/users', userData);
  }

  async updateUser(userData) {
    return this.put('/users', userData);
  }

  async getRoles() {
    return this.get('/vaitro');
  }
}

export default new ApiService();