document.addEventListener('DOMContentLoaded', function () {
	const navHTML = `
		<nav>
			<div class="main headar">
				<div class="logo">
					<a href="index.html"><img src="log1.png" alt="Chef Logo" width="100" height="100"></a>
				</div>
				<ul>
					<li><a href="om resturang.html">om resturang</a></li>
					<li><a href="meny.html">meny</a></li>
					<li><a href="om mrstrid.html ">Om</a></li>
					<li><a href="hitta-hit.html">hitta-hit</a></li>
					<li><a href="boka-bord.html">Boka bord</a></li>
					
                    
				</ul>
			</div>
		</nav>
	`;

	const placeholder = document.getElementById('site-nav');
	if (placeholder) {
		placeholder.innerHTML = navHTML;
	} else {
		document.body.insertAdjacentHTML('afterbegin', navHTML);
	}
});

  
  const reveals = document.querySelectorAll('.reveal');

  function revealOnScroll() {
    for (let i = 0; i < reveals.length; i++) {
      const windowHeight = window.innerHeight;
      const elementTop = reveals[i].getBoundingClientRect().top;

      if (elementTop < windowHeight - 100) {
        reveals[i].classList.add('active');
      }
    }
  }

  window.addEventListener('scroll', revealOnScroll);
  revealOnScroll();

  document.getElementById('booking-form').addEventListener('submit', function (e) {
            e.preventDefault();
            document.getElementById('confirmation').style.display = 'block';
            this.reset(); 
        });

		const sharp = require('sharp');
const fs = require('fs');
const directory = './images';

fs.readdirSync(directory).forEach(file => {
  sharp(`${directory}/${file}`)
    .resize(200, 100) // width, height
    .toFile(`${directory}/${file}-small.jpg`);
  });