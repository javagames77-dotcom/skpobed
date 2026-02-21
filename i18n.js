// ============================================
// InSkill Online - i18n System
// Languages: RU, UK, EN
// ============================================

const TRANSLATIONS = {
  ru: {
    // Common
    add: "Добавить", edit: "Редактировать", delete: "Удалить", save: "Сохранить", 
    cancel: "Отмена", search: "Поиск", loading: "Загрузка...", logout: "Выход",
    all: "Все", actions: "Действия", name: "Название", address: "Адрес",
    
    // Entities
    athletes: "Спортсмены", groups: "Группы", clubs: "Клубы", 
    trainers: "Тренеры", directors: "Директора", athlete: "Спортсмен",
    
    // Actions
    addAthlete: "Добавить спортсмена", addGroup: "Добавить группу", 
    addClub: "Добавить клуб", addTrainer: "Добавить тренера",
    addDirector: "Добавить директора", enrollInGroup: "Записать в группу",
    removeFromGroup: "Убрать из группы",
    
    // Fields
    firstName: "Имя", lastName: "Фамилия", email: "Email", 
    password: "Пароль", birthDate: "Дата рождения", photo: "Фото",
    club: "Клуб", group: "Группа", day: "День", month: "Месяц", year: "Год",
    
    // Stats
    total: "Всего", statistics: "Статистика", 
    childrenCount: "Спортсменов", groupsCount: "Групп", trainersCount: "Тренеров",
    
    // Messages
    deleteConfirm: "Удалить?", saved: "Сохранено!", created: "Создано!", 
    updated: "Обновлено!", deleted: "Удалено!", error: "Ошибка",
    noData: "Нет данных", networkError: "Ошибка сети",
    
    // Months
    months: ["Январь","Февраль","Март","Апрель","Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь"],
    back: "Назад", schedule: "Расписание", phone: "Телефон", qualification: "Квалификация", info: "Информация"
  },,
    
    // Additional
    back: "Назад",
    schedule: "Расписание",
    noSchedule: "Расписание не установлено",
    noTrainers: "Нет тренеров",
    noGroups: "Нет групп",
    noChildren: "Нет спортсменов",
    clubsCount: "Клубов",
    birthDate: "Дата рождения",
    qualification: "Квалификация"
  },
  
  uk: {
    add: "Додати", edit: "Редагувати", delete: "Видалити", save: "Зберегти",
    cancel: "Скасувати", search: "Пошук", loading: "Завантаження...", logout: "Вихід",
    all: "Всі", actions: "Дії", name: "Назва", address: "Адреса",
    
    athletes: "Спортсмени", groups: "Групи", clubs: "Клуби",
    trainers: "Тренери", directors: "Директори", athlete: "Спортсмен",
    
    addAthlete: "Додати спортсмена", addGroup: "Додати групу",
    addClub: "Додати клуб", addTrainer: "Додати тренера",
    addDirector: "Додати директора", enrollInGroup: "Записати в групу",
    removeFromGroup: "Прибрати з групи",
    
    firstName: "Ім'я", lastName: "Прізвище", email: "Email",
    password: "Пароль", birthDate: "Дата народження", photo: "Фото",
    club: "Клуб", group: "Група", day: "День", month: "Місяць", year: "Рік",
    
    total: "Всього", statistics: "Статистика",
    childrenCount: "Спортсменів", groupsCount: "Груп", trainersCount: "Тренерів",
    
    deleteConfirm: "Видалити?", saved: "Збережено!", created: "Створено!",
    updated: "Оновлено!", deleted: "Видалено!", error: "Помилка",
    noData: "Немає даних", networkError: "Помилка мережі",
    
    months: ["Січень","Лютий","Березень","Квітень","Травень","Червень","Липень","Серпень","Вересень","Жовтень","Листопад","Грудень"],
    back: "Назад", schedule: "Розклад", phone: "Телефон", qualification: "Кваліфікація", info: "Інформація"
  },,
    
    back: "Назад",
    schedule: "Розклад",
    noSchedule: "Розклад не встановлено",
    noTrainers: "Немає тренерів",
    noGroups: "Немає груп",
    noChildren: "Немає спортсменів",
    clubsCount: "Клубів",
    birthDate: "Дата народження",
    qualification: "Кваліфікація"
  },
  
  en: {
    add: "Add", edit: "Edit", delete: "Delete", save: "Save",
    cancel: "Cancel", search: "Search", loading: "Loading...", logout: "Logout",
    all: "All", actions: "Actions", name: "Name", address: "Address",
    
    athletes: "Athletes", groups: "Groups", clubs: "Clubs",
    trainers: "Trainers", directors: "Directors", athlete: "Athlete",
    
    addAthlete: "Add Athlete", addGroup: "Add Group",
    addClub: "Add Club", addTrainer: "Add Trainer",
    addDirector: "Add Director", enrollInGroup: "Enroll in Group",
    removeFromGroup: "Remove from Group",
    
    firstName: "First Name", lastName: "Last Name", email: "Email",
    password: "Password", birthDate: "Birth Date", photo: "Photo",
    club: "Club", group: "Group", day: "Day", month: "Month", year: "Year",
    
    total: "Total", statistics: "Statistics",
    childrenCount: "Athletes", groupsCount: "Groups", trainersCount: "Trainers",
    
    deleteConfirm: "Delete?", saved: "Saved!", created: "Created!",
    updated: "Updated!", deleted: "Deleted!", error: "Error",
    noData: "No data", networkError: "Network error",
    
    months: ["January","February","March","April","May","June","July","August","September","October","November","December"],
    
    back: "Back",
    schedule: "Schedule",
    noSchedule: "No schedule set",
    noTrainers: "No trainers",
    noGroups: "No groups",
    noChildren: "No athletes",
    clubsCount: "Clubs",
    birthDate: "Birth Date",
    qualification: "Qualification"
  }
};

let currentLang = localStorage.getItem('lang') || 'ru';

function t(key) {
  return TRANSLATIONS[currentLang][key] || key;
}

function setLang(lang) {
  if (TRANSLATIONS[lang]) {
    currentLang = lang;
    localStorage.setItem('lang', lang);
    location.reload(); // Reload page to apply translations
  }
}

// Initialize language selector
function initLangSelector() {
  const sel = document.getElementById('langSelect');
  if (sel) sel.value = currentLang;
}
