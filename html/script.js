// Global variables
let currentPlayers = [];
let currentAdminLevel = 0;
let selectedPlayer = null;
let filteredPlayers = [];

// NUI Message Handler
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.type) {
        case 'openAdminMenu':
            openAdminMenu(data.players, data.adminLevel);
            break;
        case 'closeAdminMenu':
            closeAdminMenu();
            break;
    }
});

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeEventListeners();
});

// Initialize event listeners
function initializeEventListeners() {
    // Close button
    document.getElementById('close-btn').addEventListener('click', closeAdminMenu);
    
    // Player search
    document.getElementById('player-search').addEventListener('input', filterPlayers);
    
    // Close modals when clicking outside
    window.addEventListener('click', function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.classList.add('hidden');
        }
    });
    
    // ESC key to close menu
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeAdminMenu();
        }
    });
}

// Open admin menu
function openAdminMenu(players, adminLevel) {
    currentPlayers = players;
    currentAdminLevel = adminLevel;
    filteredPlayers = [...players];
    
    document.getElementById('admin-menu').classList.remove('hidden');
    document.getElementById('admin-level').textContent = adminLevel;
    document.getElementById('player-count').textContent = players.length;
    
    renderPlayersList();
}

// Close admin menu
function closeAdminMenu() {
    document.getElementById('admin-menu').classList.add('hidden');
    closeAllModals();
    
    // Send close message to game
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

// Close all modals
function closeAllModals() {
    document.querySelectorAll('.modal').forEach(modal => {
        modal.classList.add('hidden');
    });
}

// Render players list
function renderPlayersList() {
    const playersList = document.getElementById('players-list');
    playersList.innerHTML = '';
    
    filteredPlayers.forEach(player => {
        const playerCard = createPlayerCard(player);
        playersList.appendChild(playerCard);
    });
}

// Create player card
function createPlayerCard(player) {
    const card = document.createElement('div');
    card.className = 'player-card';
    card.onclick = () => openPlayerModal(player);
    
    card.innerHTML = `
        <h4>${player.name}</h4>
        <div class="player-info">
            <p><strong>ID:</strong> ${player.id}</p>
            <p><strong>Job:</strong> ${player.job} (${player.grade})</p>
            <p><strong>Admin:</strong> ${player.admin}</p>
        </div>
        <div class="player-actions">
            <button onclick="event.stopPropagation(); quickHeal(${player.id})">
                <i class="fas fa-heart"></i> Heal
            </button>
            <button onclick="event.stopPropagation(); quickRevive(${player.id})">
                <i class="fas fa-cross"></i> Revive
            </button>
            <button onclick="event.stopPropagation(); quickTeleport(${player.id})">
                <i class="fas fa-location-arrow"></i> TP
            </button>
        </div>
    `;
    
    return card;
}

// Filter players
function filterPlayers() {
    const searchTerm = document.getElementById('player-search').value.toLowerCase();
    
    if (searchTerm === '') {
        filteredPlayers = [...currentPlayers];
    } else {
        filteredPlayers = currentPlayers.filter(player => 
            player.name.toLowerCase().includes(searchTerm) ||
            player.id.toString().includes(searchTerm) ||
            player.job.toLowerCase().includes(searchTerm)
        );
    }
    
    renderPlayersList();
}

// Open player modal
function openPlayerModal(player) {
    selectedPlayer = player;
    
    document.getElementById('modal-player-name').textContent = player.name;
    document.getElementById('modal-player-id').textContent = player.id;
    document.getElementById('modal-player-job').textContent = `${player.job} (${player.grade})`;
    document.getElementById('modal-player-admin').textContent = player.admin;
    
    document.getElementById('player-modal').classList.remove('hidden');
}

// Close player modal
function closePlayerModal() {
    document.getElementById('player-modal').classList.add('hidden');
    selectedPlayer = null;
}

// Show kick modal
function showKickModal() {
    closePlayerModal();
    document.getElementById('kick-modal').classList.remove('hidden');
}

// Close kick modal
function closeKickModal() {
    document.getElementById('kick-modal').classList.add('hidden');
    document.getElementById('kick-reason').value = '';
}

// Show ban modal
function showBanModal() {
    closePlayerModal();
    document.getElementById('ban-modal').classList.remove('hidden');
}

// Close ban modal
function closeBanModal() {
    document.getElementById('ban-modal').classList.add('hidden');
    document.getElementById('ban-reason').value = '';
    document.getElementById('ban-duration').value = '';
}

// Player actions
function teleportToPlayer() {
    if (selectedPlayer) {
        fetch(`https://${GetParentResourceName()}/teleportToPlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ playerId: selectedPlayer.id })
        });
        closePlayerModal();
    }
}

function bringPlayer() {
    if (selectedPlayer) {
        fetch(`https://${GetParentResourceName()}/bringPlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ playerId: selectedPlayer.id })
        });
        closePlayerModal();
    }
}

function spectatePlayer() {
    if (selectedPlayer) {
        fetch(`https://${GetParentResourceName()}/spectatePlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ playerId: selectedPlayer.id })
        });
        closePlayerModal();
    }
}

function healPlayer() {
    if (selectedPlayer) {
        fetch(`https://${GetParentResourceName()}/healPlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ playerId: selectedPlayer.id })
        });
        closePlayerModal();
    }
}

function revivePlayer() {
    if (selectedPlayer) {
        fetch(`https://${GetParentResourceName()}/revivePlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ playerId: selectedPlayer.id })
        });
        closePlayerModal();
    }
}

function freezePlayer() {
    if (selectedPlayer) {
        fetch(`https://${GetParentResourceName()}/freezePlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ playerId: selectedPlayer.id })
        });
        closePlayerModal();
    }
}

function kickPlayer() {
    if (selectedPlayer) {
        const reason = document.getElementById('kick-reason').value || 'Kicked by admin';
        
        fetch(`https://${GetParentResourceName()}/kickPlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ 
                playerId: selectedPlayer.id,
                reason: reason
            })
        });
        
        closeKickModal();
    }
}

function banPlayer() {
    if (selectedPlayer) {
        const reason = document.getElementById('ban-reason').value || 'Banned by admin';
        const duration = parseInt(document.getElementById('ban-duration').value) || 0;
        
        fetch(`https://${GetParentResourceName()}/banPlayer`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ 
                playerId: selectedPlayer.id,
                reason: reason,
                duration: duration
            })
        });
        
        closeBanModal();
    }
}

// Quick actions
function quickHeal(playerId) {
    fetch(`https://${GetParentResourceName()}/healPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ playerId: playerId })
    });
}

function quickRevive(playerId) {
    fetch(`https://${GetParentResourceName()}/revivePlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ playerId: playerId })
    });
}

function quickTeleport(playerId) {
    fetch(`https://${GetParentResourceName()}/teleportToPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ playerId: playerId })
    });
}

// Global actions
function healAll() {
    currentPlayers.forEach(player => {
        quickHeal(player.id);
    });
}

function reviveAll() {
    currentPlayers.forEach(player => {
        quickRevive(player.id);
    });
}

function clearArea() {
    // This would need to be implemented on the server side
    // For now, just show a notification
    console.log('Clear area functionality would be implemented here');
}

// Utility function to get resource name
function GetParentResourceName() {
    return window.location.hostname;
}