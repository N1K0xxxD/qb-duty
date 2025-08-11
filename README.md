# QBCore Admin Menu Script

A comprehensive admin menu system for QBCore FiveM servers that provides an intuitive interface for server administrators to manage players and perform various administrative actions.

## Features

### 🎯 **Core Functionality**
- **Admin Permission System** - Only players with admin levels > 0 can access the menu
- **Player Management** - View all online players with detailed information
- **Real-time Updates** - Live player data and status information

### 🚀 **Admin Actions**
- **Teleportation** - Teleport to players or bring players to you
- **Player Health** - Heal and revive players individually or all at once
- **Moderation Tools** - Kick, ban, and freeze players
- **Spectate Mode** - Watch players without being seen
- **Quick Actions** - Fast access to common admin functions

### 🎨 **User Interface**
- **Modern Design** - Beautiful, responsive interface with dark theme
- **Search Functionality** - Find players quickly by name, ID, or job
- **Modal System** - Clean, organized action menus
- **Responsive Layout** - Works on all screen sizes

## Installation

### 1. **Resource Setup**
```bash
# Place the resource in your server's resources folder
# Example: resources/qb-adminmenu/
```

### 2. **Server Configuration**
Add the resource to your `server.cfg`:
```cfg
ensure qb-adminmenu
```

### 3. **Database Setup** (Optional)
If you want to use the ban system, ensure you have a `bans` table:
```sql
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
);
```

## Usage

### **Opening the Admin Menu**
```
/admin
```
- Only players with admin level > 0 can use this command
- The menu will display all online players and available actions

### **Player Management**
1. **View Players** - See all online players with their details
2. **Search Players** - Use the search bar to find specific players
3. **Player Actions** - Click on any player card to open detailed actions

### **Available Actions**

#### **Basic Actions**
- **Teleport To** - Move to the player's location
- **Bring Player** - Move the player to your location
- **Spectate** - Watch the player without being seen
- **Heal** - Restore player's health to 100%
- **Revive** - Bring dead players back to life
- **Freeze** - Toggle player movement

#### **Moderation Actions**
- **Kick** - Remove player from server with reason
- **Ban** - Ban player temporarily or permanently with reason

#### **Global Actions**
- **Heal All** - Restore health for all online players
- **Revive All** - Bring all dead players back to life
- **Clear Area** - Clear the area around you (server-side implementation needed)

## Configuration

### **Admin Levels**
The script checks for `Player.PlayerData.admin` value:
- **Level 0** - No access (regular players)
- **Level 1+** - Full admin access

### **Customization**
You can modify the following files to customize the appearance:
- `html/style.css` - Visual styling and layout
- `html/script.js` - Functionality and behavior
- `html/index.html` - HTML structure

## File Structure

```
qb-adminmenu/
├── fxmanifest.lua      # Resource manifest
├── client.lua          # Client-side logic
├── server.lua          # Server-side logic
├── html/
│   ├── index.html      # Main interface
│   ├── style.css       # Styling
│   └── script.js       # Frontend logic
└── README.md           # This file
```

## Dependencies

- **QBCore Framework** - Core server framework
- **MySQL-Async** - Database operations (optional, for ban system)

## Security Features

- **Permission Checking** - Server-side validation of admin status
- **Input Validation** - Sanitized user inputs
- **Event Protection** - Secure event handling

## Troubleshooting

### **Common Issues**

1. **Menu Not Opening**
   - Check if you have admin permissions (admin level > 0)
   - Ensure the resource is started in server.cfg
   - Check console for any error messages

2. **Actions Not Working**
   - Verify your admin level in the database
   - Check if the target player is still online
   - Ensure all dependencies are properly installed

3. **UI Not Displaying**
   - Check if the HTML files are in the correct location
   - Verify the fxmanifest.lua includes the UI files
   - Clear browser cache if testing locally

### **Debug Mode**
Enable debug logging by adding this to your server.cfg:
```cfg
set qb_debug true
```

## Support

For support and questions:
- Check the QBCore Discord server
- Review the error logs in your server console
- Ensure all dependencies are up to date

## License

This script is provided as-is for educational and server management purposes. Feel free to modify and distribute as needed.

## Changelog

### Version 0.0.2
- Added comprehensive admin menu system
- Implemented player management features
- Added modern UI with responsive design
- Included moderation tools and quick actions

### Version 0.0.1
- Basic duty toggle functionality
- Simple command system

---

**Note**: This script is designed for QBCore servers. Make sure you have the latest version of QBCore installed for optimal compatibility.