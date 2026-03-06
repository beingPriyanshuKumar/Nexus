import '../profile_model.dart';

final feProfileData = ProfileData(
  id: 'fe-pk',
  name: 'Priyanshu Kumar',
  email: 'priyanshukumar_250101@aitpune.edu.in',
  phone: '+91 90000 12345',
  gender: 'Male',
  role: 'Member',
  domains: ['Frontend', 'UI/UX'],
  connectedClubs: ['Google Developer Groups (GDG)'],
  avatar: '',
  bannerText: 'BUILD & INNOVATE',
  bio: 'FE Student | Flutter & Frontend Enthusiast | AIT Pune',
  clubs: [
    const ClubInfo(
      id: 'c1',
      name: 'Google Developer Groups (GDG)',
      role: 'Member',
      logo: '',
      description: 'To create a strong community of student developers and connect them across the globe.',
      whatsapp: 'https://chat.whatsapp.com/gdg',
      telegram: 'https://t.me/gdg',
    ),
  ],
);

final feMembersData = [
  MemberData(id: 'm1', clubId: 'c1', name: 'Peush Yadav', email: 'peushyadav_240702@aitpune.edu.in', role: 'SE', domain: 'MERN Stack', status: 'Active'),
  MemberData(id: 'm2', clubId: 'c1, c2', name: 'APS_X', email: 'aryanpratapsingh_240114@aitpune.edu.in', role: 'SE', domain: 'Full Stack', status: 'Active'),
  MemberData(id: 'm3', clubId: 'c1', name: 'Priyanshu Kumar', email: 'priyanshukumar_250101@aitpune.edu.in', role: 'FE', domain: 'Frontend', status: 'Active'),
  MemberData(id: 'm4', clubId: 'c1, c3', name: 'Vishal Goswami', email: 'vishalgoswami_250224@aitpune.edu.in', role: 'FE', domain: 'Backend', status: 'Active'),
  MemberData(id: 'm5', clubId: 'c1', name: 'Sajal Rawat', email: 'sajalrawat_250309@aitpune.edu.in', role: 'FE', domain: 'Design', status: 'Active'),
  MemberData(id: 'm6', clubId: 'c2', name: 'Harshwardhan', email: 'harshwardhan_250452@aitpune.edu.in', role: 'FE', domain: 'Design', status: 'Active'),
];

final feTasksData = [
  TaskData(id: 't1', clubId: 'c1', title: 'Update Landing Page', description: 'Use react libraries and animate the hero page.', assignedTo: 'm1', assignedToName: 'Peush Yadav', status: 'In Progress', priority: 'High', deadline: '2026-02-22', createdAt: '2026-02-01'),
  TaskData(id: 't4', clubId: 'c1', title: 'Fix image drag', description: 'Make the images undraggable.', assignedTo: 'm4', assignedToName: 'Jitesh Yadav', status: 'Pending', priority: 'Low', deadline: '2026-02-22', createdAt: '2026-02-01'),
];

final feMessagesData = [
  const MessageData(id: 'msg1', clubId: 'c1', senderId: 'm1', senderName: 'Peush Yadav', content: 'Hey everyone, the new designs are live on Figma.', timestamp: '2026-02-01T10:30:00Z'),
  const MessageData(id: 'msg2', clubId: 'c1', senderId: 'te-1', senderName: 'Nishant Singh', content: 'Great work Sajal! I will review them shortly.', timestamp: '2026-02-01T10:35:00Z'),
  const MessageData(id: 'msg3', clubId: 'c2', senderId: 'm2', senderName: 'APS_X', content: 'Do we have a meeting today?', timestamp: '2026-02-01T11:00:00Z'),
];

final feNotificationsData = [
  NotificationData(id: 'n1', title: 'Task Assigned', message: 'You have been assigned "Fix image drag".', type: 'info', isRead: false, timestamp: '2026-02-01T09:00:00Z'),
  NotificationData(id: 'n2', title: 'New Message', message: 'Peush Yadav sent a message in Public Channel.', type: 'info', isRead: true, timestamp: '2026-02-01T10:30:00Z'),
];
